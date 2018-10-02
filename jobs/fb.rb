require 'firebase'
require 'json'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new


firebase_url    = 'https://greenbox-217603.firebaseio.com/'
firebase_secret = 'GWHsVEKBW7b5ypJjy3HMTtSa6wck1gsE90gX84fy'
firebase = Firebase::Client.new(firebase_url, firebase_secret)
valores = ['Tamaño del cesped', 'Nivel de agua', 'Nivel de suciedad', 'Flujo de personas', 'Felicidad', 'Cantidad de animales', 'Humedad', 'Porcentaje de lluvias', 'Desperfectos']
buzzword_counts = Hash.new({ value: 0 })


# response = firebase.push("", { :name => "uno",:temperatura => 44,:status => "WARNING" })
# puts response
# puts response.body
# firebase.delete("",{:name => nombre,:status => prioridad,:temperatura => temp})
scheduler.every '20s' do
  response = firebase.get("-LNRpuJlJ7yacir-VM4s")
  estado = JSON.parse(response.raw_body)['status']
  temperatura = JSON.parse(response.raw_body)['temperatura']
  cesped = JSON.parse(response.raw_body)['Cesped']
  agua = JSON.parse(response.raw_body)['Agua']
  suciedad = JSON.parse(response.raw_body)['Suciedad']
  personas = JSON.parse(response.raw_body)['Personas']
  felicidad = JSON.parse(response.raw_body)['Felicidad']
  animales = JSON.parse(response.raw_body)['Animales']
  humedad = JSON.parse(response.raw_body)['Humedad']
  lluvias = JSON.parse(response.raw_body)['Lluvias']
  desperfectos = JSON.parse(response.raw_body)['Desperfectos']
  basura = JSON.parse(response.raw_body)['Basura']

  buzzword_counts[valores[0]] = { label: valores[0], value: cesped }
  buzzword_counts[valores[1]] = { label: valores[1], value: agua }
  buzzword_counts[valores[2]] = { label: valores[2], value: suciedad }
  buzzword_counts[valores[3]] = { label: valores[3], value: personas }
  buzzword_counts[valores[4]] = { label: valores[4], value: felicidad }
  buzzword_counts[valores[5]] = { label: valores[5], value: animales }
  buzzword_counts[valores[6]] = { label: valores[6], value: humedad }
  buzzword_counts[valores[7]] = { label: valores[7], value: lluvias }
  buzzword_counts[valores[8]] = { label: valores[8], value: desperfectos }
  send_event('datos', { items: buzzword_counts.values })
  send_event('basedatos',status: estado)
  send_event('basura', {value: basura})

end


# puts response

# datos = JSON.parse(response.raw_body['status']['temperatura'])
# puts nombre
# puts prioridad
# puts temp

# firebase.update('-LNRpuJlJ7yacir-VM4s', {:name => "uno", :temperatura => 15, :status => "OK"})
