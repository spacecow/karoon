collection @categories
attributes :id
node(:name) {|cat| english? ? cat.names_depth_cache_en : cat.names_depth_cache_ir}
