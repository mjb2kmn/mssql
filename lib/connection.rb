class Connection
  
  def initialize(configs, after_connect_handler=nil)
    @configs = configs
    @after_connect_handler = after_connect_handler
    use :default_connection
  end
  
  attr_reader :results, :error, :name

  def error?
    !@error.nil?
  end

  def one_column_one_row?
    return false if error?
    @results.rows.size == 1 && @results.columns.size == 1
  rescue
    false
  end

  def exec(sql)
    begin
      result = @client.execute sql
      rows = result.each(:symbolize_keys => true, :empty_sets => true, :as => :array)
      @results = Hashie::Mash.new({
                                    :columns => result.fields, 
                                    :rows => rows, 
                                    :affected => result.do, 
                                    :return_code => @client.return_code
                                  })
      @error = nil
      @results
    rescue TinyTds::Error => e
      @result = nil
      @error = Hashie::Mash.new(:error => e.to_s, :severity => e.severity, :db_error_number => e.db_error_number)
    end
  end

  KEYS = [:username, :password, :host, :database] 

  def use(name = :default_connection)
    return false unless @configs.has_key?(name.to_s)
    connect @configs[name.to_s]
    return true
  end

  private
  
  def connect(config)
    new_client = TinyTds::Client.new(config.to_hash.symbolize_keys)
    @client.close if @client
    @client = new_client
    @name = config.name || "#{config.username}@#{config.host}"   
    @after_connect_handler.call(@name) if @after_connect_handler 
  end
  
end
