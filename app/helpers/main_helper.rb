module MainHelper
  def get_escaped_json(obj)
    obj.to_json.gsub(/\"/, "\\\"")
  end
end
