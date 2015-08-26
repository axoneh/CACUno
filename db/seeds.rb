# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Anticoagulante.delete_all
Anticoagulante.create(nombre: 'Warfarina x 5mg', concentracion: 5, estado: 1)
Anticoagulante.create(nombre: 'Warfarina x 10mg', concentracion: 10, estado: 1)

Icd.create(id10: "lawe", dec10: "Enfermedad sin descripcion presisa", grp10: nil)
Icd.create(id10: "xdpm", dec10: "Etra enfermedad sin descripcion presisa", grp10: nil)

AntecedenteMedico.delete_all
AntecedenteMedico.create(nombre: 'Farmacos que interfieran con el anticoagulante', descripcion: 'Cual(es)', tag: 'farmaco', tipo: true, estado: 1)
AntecedenteMedico.create(nombre: 'Consumo de alcohol', tag: 'alcohol', tipo: false, estado: 1)
AntecedenteMedico.create(nombre: 'Alto consumo de alimento verdes', descripcion: 'Que alimentos en especifico', tag: 'alimentos verdes' , tipo: true, estado: 1)
AntecedenteMedico.create(nombre: 'Tiene diabetes', tag: 'diabetes', tipo: false , estado: 1 )
AntecedenteMedico.create(nombre: 'Algun antecedente renal', tag: 'antecedente renal', tipo: false, estado: 1)
AntecedenteMedico.create(nombre: 'Algun antecedente hepatico', tag: 'antecedente hepatico', tipo: false, estado: 1)
AntecedenteMedico.create(nombre: 'Insuficiencia cardiaca congestiva', tag: 'insuficiencia cardiaca', tipo: false, estado: 1)
AntecedenteMedico.create(nombre: 'Eventos cerebro vasculares previos', tag: 'ecv previo', tipo: false, estado: 1)
AntecedenteMedico.create(nombre: 'Alguna enfermedad vascular que nombre', tag: 'enfermedad vascular', tipo: true, estado: 1, descripcion: 'Cual(es)')
AntecedenteMedico.create(nombre: 'Evento hemorragico', tag: 'evento hemorragico', tipo: false, estado: 1)

DiaAsociado.delete_all
DiaAsociado.create(numero:1, nombre: 'Lunes', estado:1)
DiaAsociado.create(numero:2, nombre: 'Martes', estado:1)
DiaAsociado.create(numero:3, nombre: 'Miercoles', estado:1)
DiaAsociado.create(numero:4, nombre: 'Jueves', estado:1)
DiaAsociado.create(numero:5, nombre: 'Viernes', estado:1)
DiaAsociado.create(numero:6, nombre: 'Sabado', estado:1)
DiaAsociado.create(numero:7, nombre: 'Domingo', estado:1)

EstadoCivil.delete_all
EstadoCivil.create(nombre: 'Casado', estado: 1)
EstadoCivil.create(nombre: 'Soltero', estado: 1)

Patologia.delete_all
Patologia.create(nombre: 'Fibrilacion auricular', descripcion: 'Vibracion de las auriculas del corazon', estado: 1)
Patologia.create(nombre: 'Valvulopatia', descripcion: 'Agregado de una vavula artifical', estado: 1)
Patologia.create(nombre: 'Tromboembolismo pulmonar', descripcion: '(Sin descripcion)', estado: 1)
Patologia.create(nombre: 'Trombosis venosa profunda', descripcion: '(Sin descripcion)', estado: 1)

Pregunta.delete_all
Pregunta.create(pregunta: 'Ha tenido sangrado nasal', tag: 'sangrado nasal' , tipo: false, estado: 1)
Pregunta.create(pregunta: 'Ha estado adherido', tag: 'adherido', tipo: false, estado: 1)
Pregunta.create(pregunta: 'Tuvo o tiene el ojo hematico', tag: 'ojo hematico', tipo: false, estado: 1)
Pregunta.create(pregunta: 'Le ha sangrado alguna parte interna de la boca', tag: 'sangrado oral', tipo: false, estado: 1)
Pregunta.create(pregunta: 'Sufrio su piel algun cambio de color', tag: 'cambio color piel' , tipo: false, estado: 1)
Pregunta.create(pregunta: 'Color oscuro de la deposicion', tag: 'color deposicion', tipo: false, estado: 1)
Pregunta.create(pregunta: 'Presencia de sangre en la orina', tag: 'Hematuria', tipo: false, estado: 1)
Pregunta.create(pregunta: 'Tiene INR inestable o dificil', tag: 'inr dificil', tipo: false, estado: 1)


Rol.delete_all
Rol.create(nombre: 'Administrador', descripcion: '(Sin descripcion)')
Rol.create(nombre: 'Medico Especialista', descripcion: '(Sin descripcion)')
Rol.create(nombre: 'Paramedico', descripcion: '(Sin descripcion)')

TipoDocumento.delete_all
TipoDocumento.create(nombre: 'Cedula de ciudadania', estado: 1)

Sucursal.delete_all
Sucursal.create(nombre: 'Principal', direccion: '(Sin agregar)' , estado: 1)

#-----------------------------------------------------------------------
CuentaUsuario.delete_all
CuentaUsuario.create(identificacion: "1032485940", especialidad: "Administrador", tipo_documentos_id: TipoDocumento.find_by(nombre: "Cedula de ciudadania").id, nombre: 'Diego Alejandro', apellido: 'Correa Ramirez' , email: 'alejandro@axoneh.com', password: 'MARIObros12', direccion: 'Cll 35b Sur #73a 81', genero: true, estado: 1, rols_id: Rol.find_by(nombre: 'Administrador').id)
CuentaUsuario.create(identificacion: "3432", especialidad: "Administrador", tipo_documentos_id: TipoDocumento.find_by(nombre: "Cedula de ciudadania").id, email: 'carlos@axoneh.com', estado: 2, rols_id: Rol.find_by(nombre: 'Administrador').id)

Paciente.delete_all
#-----------------------------------------------------------------------
AntecedentePaciente.delete_all
CitaMedica.delete_all
InrPaciente.delete_all
Laboratorio.delete_all
#-----------------------------------------------------------------------
PreguntaCita.delete_all
RespuestaCita.delete_all
#-----------------------------------------------------------------------
ObservacionMedica.delete_all
Prescripcion.delete_all
#-----------------------------------------------------------------------
PrescripcionDiaria.delete_all
