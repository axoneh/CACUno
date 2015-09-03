module ApplicationHelper
   def controllername
     a=params[:controller]
     if a=="devise/sessions"
       return "inicio"
     else
       return nil
     end
  end
  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename).body.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    if options[:class].present?
      svg["class"] = options[:class]
    end
    raw doc
  end
end
