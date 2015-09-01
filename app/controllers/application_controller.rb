class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :tipoUsuario, :authenticate_cuenta_usuario!

protected

  def tipoUsuario
    @admin=validacionAdmin()
    @medico=validacionMedico()
    @paramedico=validacionParamedico()
    @autorizado=validacionAutorizado()
    @encargado=validacionEncargadoRespuesta()
    @autenticado=usuarioAutenticado()
  end

  def usuarioAutenticado
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==1
        return true
      end
    end
  end

  def validacionMedico #validacion para saber si fue un medico quien entro al sistema
    if usuarioAutenticado
      if current_cuenta_usuario.rols.nombre=="Medico Especialista"
        return true
      end
    end
  end 

  def validacionEncargadoRespuesta #validacion para saber si quien entro al sistema esta autorizado para realizar respuestas a consultas domiciliarias
    if validacionMedico()
      if current_cuenta_usuario.encargado_respuesta
        return true
      end
    end
  end

  def validacionAdmin #validacion para saber si fue un admin quien entro al sistema
    if usuarioAutenticado
      if current_cuenta_usuario.rols.nombre=="Administrador"
        return true
      end
    end
  end

  def validacionParamedico #validacion para saber si fue un paramedico quien entro al sistema
    if usuarioAutenticado
      if current_cuenta_usuario.rols.nombre=="Paramedico"
        return true
      end
    end
  end

  def validacionAutorizado #validacion para saber si quien entro al sistema esta por validar datos
    if cuenta_usuario_signed_in?
      if current_cuenta_usuario.estado==2
        return true
      end
    end
  end

  def rango_antic
    @valorMax=3
    @valorMin=2
    @ultimaCita=@paciente.cita_medicas.where(["generico = ? and estado = ?", false, 2]).last
    if @ultimaCita
      @valorMax=@ultimaCita.respuesta_cita.valor_max
      @valorMin=@ultimaCita.respuesta_cita.valor_min
    end
    @ultimaPrescripcion=@paciente.prescripcions.last
  end

  def calcularTTR(arreglo)
    rango_antic()
    valorTTR=0
    for i in 0..(arreglo.size()-2)
      
      fmin=nil
      fmax=nil
      
      dDias=(arreglo[i+1].last.to_date - arreglo[i].last.to_date).to_i
      if dDias ==0
        next
      end
      pendiente=((arreglo[i+1].first.to_f - arreglo[i].first.to_f)/dDias).to_f
      constante=arreglo[i].first
      
      if arreglo[i].first.to_f<@valorMin
        
        if arreglo[i+1].first.to_f>=@valorMin
          
          fmin=@valorMin-constante
          if pendiente!=0
            fmin=fmin/pendiente
          end
          
          if arreglo[i+1].first.to_f<=@valorMax
            
            fmax=dDias
          
          else
          
            fmax=@valorMax-constante
            if pendiente!=0
              fmax=fmax/pendiente
            end
          
          end
          
        end
        
      elsif arreglo[i].first.to_f>@valorMax
        
        if arreglo[i+1].first.to_f<=@valorMax
          
          fmin=@valorMax-constante
          if pendiente!=0
            fmin=fmin/pendiente
          end
          
          if arreglo[i+1].first.to_f<@valorMin
          
            fmax=@valorMax-constante
            if pendiente!=0
              fmax=fmax/pendiente
            end
          
          else
          
            fmax=dDias
          
          end
        
        end
        
      else
        
        fmin=0
        
        if arreglo[i+1].first.to_f<=@valorMax and arreglo[i+1].first.to_f>=@valorMin
        
          fmax=dDias
        
        else
        
          fmax=@valorMax-constante
          if pendiente!=0
            fmax=fmax/pendiente
          end
        
        end
        
      end
      
      if fmin and fmax
        valorTTR+=(fmax-fmin)
      end
    end
    dDias=(arreglo.last.last.to_date - arreglo.first.last.to_date).to_i
    valorTTR=valorTTR*100/dDias
    valorTTR=eval(sprintf("%3.1f",valorTTR))
    return valorTTR
    
  end

end
