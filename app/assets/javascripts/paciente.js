//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function validacionAgregacion(){
	if(document.getElementById('paciente_agregar')){
		var validacion=true;
		if(!document.getElementById('avatar').value){
			document.getElementById('divFotoPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('identificacion').value.legth==0){
			document.getElementById('divIdPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('nombre').value.legth==0){
			document.getElementById('divNombrePaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('apellido').value.legth==0){
			document.getElementById('divApellidoPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('correo').value.legth==0){
			document.getElementById('divCorreoPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('direccion').value.legth==0){
			document.getElementById('divDireccionPaciente').className="form-group has-error";
			validacion=false;
		}
		if(!document.getElementById('fecha_n').value){
			document.getElementById('divNacPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('antecedentes').value.legth==0){
			document.getElementById('divAnteGPaciente').className="form-group has-error";
			validacion=false;
		}
		return validacion;
	}
	else{
		return false;
	}
}

function validacionActualizacion(){
	if(document.getElementById('paciente_agregar')){
		var validacion=true;
		if(document.getElementById('identificacion').value.legth==0){
			document.getElementById('divIdPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('nombre').value.legth==0){
			document.getElementById('divNombrePaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('apellido').value.legth==0){
			document.getElementById('divApellidoPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('correo').value.legth==0){
			document.getElementById('divCorreoPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('direccion').value.legth==0){
			document.getElementById('divDireccionPaciente').className="form-group has-error";
			validacion=false;
		}
		if(!document.getElementById('fecha_n').value){
			document.getElementById('divNacPaciente').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('antecedentes').value.legth==0){
			document.getElementById('divAnteGPaciente').className="form-group has-error";
			validacion=false;
		}
		return validacion;
	}
	else{
		return false;
	}
}

function validacionAgrecacionInr(){
	if(document.getElementById('agregar_inr')){
		var validacion=true;
		return validacion;
	}
	else{
		return false;
	}
}


