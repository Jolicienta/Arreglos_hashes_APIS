#Requerimientos
#1. Crear el método request que reciba una url y retorne el hash con los resultados.
require "uri"
require 'net/http'
require 'json'

def request(url)
  # Utilizamos URI para analizar la URL y obtener la información necesaria para hacer la solicitud
  uri = URI(url)
  # Hacemos la solicitud HTTP y obtenemos la respuesta
  response = Net::HTTP.get(uri) 
  #Este codigo transforma a formato JSON lo obtenido en la variable response
  JSON.parse(response)
end

# Se crea una variable url que pueda recibir cualquier url
# No cambie el valor de ?sol aqui porque al pedir las urls de fotos mas abajo limito que sean 10.
# Me canviene que me devuelva todo para el ejercicio 3 del conteo de fotos por camara.
url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=eOyoxUVwz62M7qNvOA4BpgbL1jp2xLmcDudcGibr'

# Aqui se retorna el hash con los resultados al entregarle la url al metodo request
puts request(url)



#2. Crear un método llamado buid_web_page que reciba el hash de respuesta con todos
#los datos y construya una página web.

# Utilizo la libreria sinatra de ruby para crear de manera mas sencilla un metodo de ruby que me
# construya una web
require 'sinatra'

# Creo la variable que recibira el hash y que se le dara de argumento al metodo build_web_page y photos_count
result_request = request(url)

# Metodo que creara la pagina web
def build_web_page(hash)
    # Abrimos la variable `html` para crear la web a traves de ruby
    html = "<html><head><body><ul>"
    # Para solo obtener 10 urls de fotos defino esta variable
    selected_photos = hash["photos"][0...10]

    selected_photos.each do |photo|
    url = photo["img_src"]
    # Construimos un elemento <li> con cada foto cada vez que .each itera
    html += "<li><img src='#{url}'></li>"
    end
    # Cerramos la variable `html`
    html += "</ul></body></html>"

    return html 
end

# Utilizamos el método `erb` para mostrar el contenido HTML creado por la función `buid_web_page`
get '/' do
    erb buid_web_page(result_request)  
end


#3. Crear un método photos_count que reciba el hash de respuesta y devuelva un nuevo
#hash con el nombre de la cámara y la cantidad de fotos.

def photos_count(hash)
    total_cameras = hash["photos"]
    array_cameras = []

    total_cameras.each do |photo|
        camera_name = photo["camera"]["name"]
        array_cameras.push(camera_name)
    end

    counts = array_cameras.group_by(&:itself).map {|k,v| [k, v.count]}.to_h
end

puts photos_count(result_request)