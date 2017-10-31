require 'csv'

module DatabaseI18n
  module Services
    class CsvLoad
      def self.export_and_send
        file = CSV.generate(headers: true) do |csv|
          export(csv)
        end
        file
      end

      def self.export_and_save
        CSV.open("#{DateTime.current}_translation.csv",'wb') do |csv|
          export(csv)
        end
      end

      def self.import(file)
        return nil unless file
        successful = ActiveRecord::Base.transaction do
          CSV.foreach(file, { headers: true, header_converters: :symbol}) do |line|
            keys = line[:key].split('.')
            current = DatabaseI18n::Key.roots.find_by(name: keys.shift)
            keys.each do |key|
              current =  current.children.find_by(name: key)
              raise ArgumentError.new, "Key #{line[:key]} does not exist!" unless current
            end
            next if current.children.any?
            line.except(:key).each do |key, value|
              if I18n.available_locales.include?(key.to_sym)
                current.create_translation unless current.translation

                current.translation.update({locale: key, value: value})
              end
            end
          end
        end
      rescue ArgumentError => e
        puts e.message
        return successful
      end



      private

      def self.export(csv)

        headers = %w{key}
        headers += I18n.available_locales

        csv << headers
        DatabaseI18n::Value.all.order(:id).with_translations.each do |t|
          values = []
          I18n.available_locales.each do |locale|
            values << t.translations.find_by_locale(locale)&.body
          end
          csv << [ t.path, *values]
        end
      end
    end
  end
end
