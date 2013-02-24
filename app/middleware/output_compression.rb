class OutputCompression < Rack::Deflater
  def call(env)
    if env['PATH_INFO'].match(/\.(gif|jpe?g|png|eot|woff)$/i)
      @app.call(env)
    else
      super(env)
    end
  end
end