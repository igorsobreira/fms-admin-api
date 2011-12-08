
FMS::ApiMethod.new do |m|
  m.name = 'get_apps'
  m.desc = 'Lists the names of all installed applications'

  m.on_call do
    self.do_get('getApps')
  end

end
