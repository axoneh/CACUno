//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function validacionAgregacion(){
	if(document.getElementById('paciente_agregar')){
		var val=0;
		val+=validacion('antecedentes','divAnteGPaciente');
		val+=validacion('fecha_n','divNacPaciente');
		val+=validacion('direccion','divDireccionPaciente');
		val+=validacion('correo','divCorreoPaciente');
		val+=validacion('apellido','divApellidoPaciente');
		val+=validacion('identificacion','divIdPaciente');
		val+=validacion('nombre','divNombrePaciente');
		val+=validacion('avatar','divFotoPaciente');
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

function validacionActualizacion(){
	if(document.getElementById('paciente_actualizar')){
		var val=0;
		val+=validacion('antecedentes','divAnteGPaciente');
		val+=validacion('fecha_n','divNacPaciente');
		val+=validacion('direccion','divDireccionPaciente');
		val+=validacion('correo','divCorreoPaciente');
		val+=validacion('apellido','divApellidoPaciente');
		val+=validacion('identificacion','divIdPaciente');
		val+=validacion('nombre','divNombrePaciente');
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

function validacionAgregacionInr(){
	if(document.getElementById('agregar_inr')){
		var val=0;
		val+=validacion('inr','divAgregarValorInr');
		val+=validacion('fecha_inr','divAgregarFechaInr');
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

function validacionAgregacionLab(){
	if(document.getElementById('agregar_lab')){
		var val=0;
		val+=validacion('observacion','divObservacionLab');
		val+=validacion('fecha_lab','divFechaLab');
		val+=validacion('rep','divRep');
		val+=validacion('lab','divLab');
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

function habilitarDescripcionAntecedente(antec){
	var input=document.getElementById(antec);
	var ayuda=antec+'_comentario';
	var desc=document.getElementById(ayuda);
	if(input.checked==true){
		desc.readOnly=false;
		desc.focus();
	}
	else{
		desc.readOnly=true;
	}
}

function buscarPaciente(){
	if(document.getElementById('buscar_paciente')){
		var texto=document.getElementById('busqueda').value;
		console.log(texto);
		if(texto.length>2){
			return true;
		}
	}
	return false;
}


