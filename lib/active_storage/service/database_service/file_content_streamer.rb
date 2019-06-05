module ActiveStorage
  # Wraps a database table as an Active Storage service. See ActiveStorage::Service for the generic API
  # documentation that applies to all services.
  class Service::DatabaseService < Service; end

  class Service::DatabaseService::FileContentStreamer

    def initialize(key, chunk_size)
      @key = key
      @chunk_size = chunk_size
    end

    def reset
      @position = 1
    end

    def each
      contents = database_service.download_chunk(key, range(@position, @chunk_size))
      @position += @chunk_size
      return contents
    end

    def range(start_position, size)
      Struct.new(:begin, :size).tap { |s| s.begin, s.size = start_position, size }
    end
  end
end

