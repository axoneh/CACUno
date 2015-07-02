# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Anticoagulante.delete_all
Anticoagulante.create(nombre: 'Warfarina', descripcion: 'Tableta x 5 mg', estado: 1)
Anticoagulante.create(nombre: 'Dabigatran', descripcion: 'Capsula x 75 mg', estado: 1)

AntecedenteMedico.delete_all

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

Pregunta.delete_all

Rol.delete_all
Rol.create(nombre: 'Administrador', descripcion: '(Sin descripcion)')
Rol.create(nombre: 'Medico Internista', descripcion: '(Sin descripcion)')

TipoDocumento.delete_all
TipoDocumento.create(nombre: 'Cedula de ciudadania', estado: 1)

Autorizado.delete_all
Autorizado.create( rols_id: 1, correo: 'alejandro@axoneh.com', password: 'hk3nol',estado: true)
#-----------------------------------------------------------------------
CuentaUsuario.delete_all
CuentaUsuario.create(identificacion: 1032485940, tipo_documentos_id: 1, nombre: 'Diego Alejandro', apellido: 'Correa Ramirez' , correo: 'alejandro@axoneh.com', password: 'MARIObros12', direccion: 'Cll 35b Sur #73a 81', estado_civils_id: 2, genero: true, autorizados_id: 1, estado: true)

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
