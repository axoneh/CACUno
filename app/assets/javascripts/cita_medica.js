//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/

function tratamientoDefinido(){
	if(document.getElementById('temporal').checked==true){
		document.getElementById('semanas_t').readOnly=false;
		document.getElementById('semanas_t').focus();
	}
	else{
		document.getElementById('semanas_t').readOnly=true;
	}
}

function habilitarDescripcionPregunta(preg){
	var input=document.getElementById(preg);
	var ayuda=preg+'_comentario';
	var desc=document.getElementById(ayuda);
	if(desc!=null){
		if(input.checked==true && desc!=null){
			desc.readOnly=false;
			desc.focus();
		}
		else{
			desc.readOnly=true;
		}
	}
}

function validacionRespuesta(){
	if(document.getElementById("agregar_respuesta")){
		var val=0;
		val+=validacionC('analisis', 'divAnalisis');
		val+=validacionC('plan', 'divPlan');
		val+=validacionC('valor_min', 'divRangoMin');
		val+=validacionC('valor_max', 'divRangoMax');
		val+=validacionC('fecha_fin', 'divDiasTratamiento');
		if (val==0){
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

function validacionConsulta(){
	if(document.getElementById('efectuar_medico')){
		var val=0;
		val+=validacionC('fecha_fin', 'divDiasTratamiento');
		val+=validacionC('valor_max', 'divRangoMax');
		val+=validacionC('valor_min', 'divRangoMin');
		val+=validacionC('plan', 'divPlan');
		val+=validacionC('analisis', 'divAnalisis');
		val+=validacionC('hdia','divDiastolica');
		val+=validacionC('hsis','divSistolica');
		val+=validacionC('frecuencia_car','divFrecuencia');
		val+=validacionC('objetiva','divObjetiva');
		if(document.getElementById('temporal').checked==true && !document.getElementById('semanas_t').value){
			document.getElementById('divTratamiento').className="form-group has-error";
			document.getElementById('semanas_t').focus();
			val++;
		}
		else{
			document.getElementById('divTratamiento').className="form-group";
		}
		val+=validacionC('subjetiva','divSubjetiva');
		val+=validacionC('inr','divInrCita');
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

function validacionVisita(){
	if(document.getElementById('efectuar_paramedico')){
		var val=0;
		val+=validacionC('hsis','divSistolica');
		val+=validacionC('hdia','divDiastolica');
		val+=validacionC('frecuencia_car','divFrecuencia');
		val+=validacionC('observacion_g','divObservacion');
		val+=validacionC('inr','divInrCita');
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

function validacionC(control,divContenedor){
	var input=document.getElementById(control);
	if(input.value==null){
		document.getElementById(divContenedor).className="form-group has-error";
		input.focus();
		return 1;
	}
	else if(input.value.length==0){
		document.getElementById(divContenedor).className="form-group has-error";
		input.focus();
		return 1;
	}
	else{
		document.getElementById(divContenedor).className="form-group has-success";
		return 0;
	}
}

function cambioAnticoagulante(){
	if(document.getElementById('antic')){
		var antic=document.getElementById('antic').value;
		antic+="_cont";
		var concent=document.getElementById(antic).value;
		var lista=document.getElementsByTagName('input');
		var suma=0;
		var id_number="";
		for(var i=0;i<lista.length;i++){
			if(lista[i].type=="number"){
				id_number=lista[i].id;
				id_number+="_dosis_dia";
				document.getElementById(id_number).innerHTML=(lista[i].value*concent)+" mg.";
				suma+=(lista[i].value*concent);	
			}
		}
		document.getElementById('dosisSemanal').innerHTML="Dosis Semanal: "+suma+" mg.<br />Promedio de dosis semanal: "+(suma/7)+" mg.";
	}
}

