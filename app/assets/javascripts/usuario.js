//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function validacion(control,divContenedor){
	input=document.getElementById(control);
	if(!input.value | input.value.legth==0){
		document.getElementById(divContenedor).className="form-group has-error";
		input.focus();
		return 1;
	}
	else{
		document.getElementById(divContenedor).className="form-group has-success";
		return 0;
	}
}

function validacionActualizacionUsuario(){
	if(document.getElementById('actualizacion_usuario')){
		var val=0;
		val+=validacion('nombre', 'divNombreUsuario');
		val+=validacion('apellido', 'divApellidoUsuario');
		val+=validacion('fecha', 'divFechaUsuario');
		val+=validacion('direccion', 'divDireccionUsuario');
		val+=validacion('telefono', 'divTelefonoUsuario');
		if(val==0){
			return true;
		}
		else{
			return false;
		}
	}
	else{
		return false;
	}
}
