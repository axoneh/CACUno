module ApplicationHelper
   def controllername
     a=params[:controller]
     if a=="devise/sessions"
       return "inicio"
     else
       return nil
     end
  end 
end
