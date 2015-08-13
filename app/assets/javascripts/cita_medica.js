//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function validacionBusquedaICD(){
	if(document.getElementById('buscar_icd')){
		if(document.getElementById('icd_b').value.legth>2){
			document.getElementById('busqueda_icd').className="form-group";
			return true;
		}
		else{
			document.getElementById('busqueda_icd').className="form-group has-error";
			return false;
		}
	}
	else{
		return false;
	}
}

function tratamientoDefinido(){
	if(document.getElementById('temporal').checked==true){
		document.getElementById('semanas_t').readonly=false;
	}
	else{
		document.getElementById('semanas_t').readonly=true;
	}
}

function preguntaDescripcion(idcheck){
	if(document.getElementById(idcheck).checked==true){
		var ayuda='c_'+idcheck;
		document.getElementById(ayuda).innerHTML="<textarea id='"+idcheck+"_comentario' name='"+idcheck+"_comentario' class='form-control' placeholder='DESCRIPCION'></textarea>";
	}
	else{
		document.getElementById(ayuda).innerHTML="";
	}
}

function validacionRespuesta(){
	if(document.getElementById('agregar_respuesta')){
		var validacion=true;
		if(document.getElementById('recomendacion').value.legth==0){
			document.getElementById('divRecomendacion').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('fecha_fin').value.legth==0){
			document.getElementById('divDiasTratamiento').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('valor_max').value.legth==0){
			document.getElementById('divRangoMax').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('valor_min').value.legth==0){
			document.getElementById('divRangoMin').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('plan').value.legth==0){
			document.getElementById('divPlan').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('analisis').value.legth==0){
			document.getElementById('divAnalisis').className="form-group has-error";
			validacion=false;
		}
		return validacion;
	}
	else{
		return false;
	}
}

function validacionCitaMedica(){
	if(document.getElementById('efectuar_medico')){
		var validacion=true;
		if(document.getElementById('recomendacion').value.legth==0){
			document.getElementById('divRecomendacion').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('fecha_fin').value.legth==0){
			document.getElementById('divDiasTratamiento').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('valor_max').value.legth==0){
			document.getElementById('divRangoMax').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('valor_min').value.legth==0){
			document.getElementById('divRangoMin').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('plan').value.legth==0){
			document.getElementById('divPlan').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('analisis').value.legth==0){
			document.getElementById('divAnalisis').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('hdia').value.legth==0){
			document.getElementById('divDiastolica').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('hsis').value.legth==0){
			document.getElementById('divSistolica').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('frecuencia_car').value.legth==0){
			document.getElementById('divFrecuencia').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('temporal').checked==true & document.getElementById('semanas_t').value.legth==0){
			document.getElementById('divTratamiento').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('objetiva').value.legth==0){
			document.getElementById('divObjetiva').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('subjetiva').value.legth==0){
			document.getElementById('divSubjetiva').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('inr').value.legth==0){
			document.getElementById('divInrCita').className="form-group has-error";
			validacion=false;
		}
		return validacion;
	}
	else{
		return false;
	}
}

function validacionCitaParamedico(){
	if(document.getElementById('efectuar_paramedico')){
		var validacion=true;
		if(document.getElementById('inr').value.legth==0){
			document.getElementById('divInrCita').className="form-group has-error";
			validacion=false;
		}
		if(document.getElementById('observacion').value.legth==0){
			document.getElementById('divObservacion').className="form-group has-error";
			validacion=false;
		}
		return validacion;
	}
	else{
		return false;
	}
}


