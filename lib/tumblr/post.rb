module Tumblr
  class Client
    module Post
      
      @@standard_post_options  = [:state, :tags, :tweet, :date, :markdown, :slug, :format]
      
      def edit(blog_name, options={})
        post("v2/blog/#{blog_name}/post/edit", options)  
      end

      #Don't be lazy and create a nice interface
      def reblog(blog_name, options={})
        post("v2/blog/#{blog_name}/post/reblog", options)  
      end
      
      def delete(blog_name, id)
        post("v2/blog/#{blog_name}/post/delete", {:id => id})  
      end

      def photo(blog_name, options={})
        valid_opts = @@standard_post_options + [:caption, :link, :data, :data_raw, :source, :photoset_layout]
        if valid_options(valid_opts, options)
          options[:type] = "photo"
          if (options.has_key?(:data) && options.has_key?(:source))
            raise Exception, "You can only use one parameter, either source or data."
          end
          if options.has_key?(:source) && options[:source].kind_of?(Array)
            count = 0
            options[:source].each do |src|
              options["source[#{count}]"] = src
              count += 1
            end
            options.delete(:source)
          end

          if options.has_key?(:data) && options.has_key?(:data_raw)
            raise ArgumentError.new 'You can only use data or data_raw'
          end

          # Allow data to be passed as filenames
          if options.has_key?(:data)
            data = options.delete :data
            data = [data] unless Array === data
            data.each.with_index do |filepath, idx|
              options["data[#{idx}]"] = File.open(filepath, 'rb').read
            end
          end

          # Allow raw data to be passed in also
          if options.has_key?(:data_raw)
            data_raw = options.delete :data_raw
            data_raw = [data_raw] unless Array === data_raw
            data_raw.each.with_index do |dr, idx|
              options[:"data[#{idx}]"] = dr
            end
          end

          post("v2/blog/#{blog_name}/post", options)
        end
      end

      def quote(blog_name, options={})
        valid_opts = @@standard_post_options + [:quote, :source]
        if valid_options(valid_opts, options)
          options[:type] = "quote"
          post("v2/blog/#{blog_name}/post", options)
        end
      end

      def text(blog_name, options={})
        valid_opts = @@standard_post_options + [:title, :body]
        if valid_options(valid_opts, options)
          options[:type] = "text"
          post("v2/blog/#{blog_name}/post", options)
        end
      end

      def link(blog_name, options={})
        valid_opts = @@standard_post_options + [:title, :url, :description]
        if valid_options(valid_opts, options)
          options[:type] = "link"
          post("v2/blog/#{blog_name}/post", options)
        end
      end

      def chat(blog_name, options={})
        valid_opts = @@standard_post_options + [:title, :conversation]
        if valid_options(valid_opts, options)
          options[:type] = "chat"
          post("v2/blog/#{blog_name}/post", options)
        end
      end

      def audio(blog_name, options={})
        valid_opts = @@standard_post_options + [:data, :caption, :external_url]
        if valid_options(valid_opts, options)
          options[:type] = "audio"
          if (options.has_key?(:data) && options.has_key?(:external_url))
            raise Exception, "You can only use one parameter, either data or external url."
          end
          if(options.has_key?(:data))
            options[:data] = File.open(options[:data],'rb').read()
          end
          post("v2/blog/#{blog_name}/post", options)
        end
      end
      
      def video(blog_name, options={})
        valid_opts = @@standard_post_options + [:data, :embed, :caption]
        if valid_options(valid_opts, options)
          options[:type] = "video"
          if (options.has_key?(:data) && options.has_key?(:embed))
            raise Exception, "You can only use one parameter, either data or embed."
          end
          if(options.has_key?(:data))
            options[:data] = File.open(options[:data],'rb').read()
          end
          post("v2/blog/#{blog_name}/post", options)
        end
      end

    end
  end
end
