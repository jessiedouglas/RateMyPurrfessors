module ApplicationHelper
  def authenticity_token
    token = <<-HTML
      <input type="hidden"
          name="authenticity_token"
          value="#{form_authenticity_token}">
    HTML

    token
  end
end
