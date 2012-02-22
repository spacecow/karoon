task :translation_keys => :environment do
  Translation.generate_keys('log/translation.log') 
end

