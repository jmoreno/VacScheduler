# La PadrinoKata
>Le haré una oferta que no podrá rechazar. Vito Corleone. 

En la misma película de la que he sacado esta cita se dice que los italianos piensan que el mundo es tan duro que hay que tener dos padres y por eso todos tienen un padrino. Quizá pensaron en esta cita los desarrolladores del nuevo framework del que me he hecho fan, Padrino, por que el nombre le viene que ni pintado. 

Creo que mi búsqueda del backend perfecto empieza a ser preocupante y enfermiza. Vaya por delante que lo que yo busco es algo que me sirva para aplicaciones móviles, que pueda tener una pequeña interfaz web y que me deje ver la base de datos, que a mi me gusta mucho el SQL, para que nos vamos a engañar. 

Ruby on Rails siempre me ha parecido una buena opción ya que es relativamente sencillo y con pocos paso puedes tener mucho del desarrollo hecho. Si a eso le añades la versatilidad que tiene para mostrar los datos en HTML, XML o json tienes un gran complemento para dispositivos móviles. Sin embargo reconozco que para devolver un pequeño json no es necesario montar el pifostio que se monta con Rails. 

En el otro extremo está Sinatra. Es sencillo, mucho más orientado a montar API's pero también te permite crear interfaces. La principal ventaja es que reduce a la mínima expresión lo que hay que escribir para que un servicio funcione. Sin embargo, puede llegar un momento en el que te canses de tanta sencillez y manualidad. 

Padrino está justo en el medio de Rails y Sinatra. Esta construido sobre Sinatra pero incorpora utilidades que hacen más eficiente el desarrollo. Sólo una curiosidad, este post hacia bastante tiempo que pensaba escribirlo. Incialmente iba a hacerlo en Rails (hace año y pico), luego pensé en hacerlo en Sinatra (hace meses). Descubrí Padrino la semana pasada y aquí esta terminado. De la noche a la mañana he encontrado el framework que mejor se adapta a mis necesidades particulares. 

Bueno, después del coñazo que he soltado vamos a ver si hacemos algo más interesante como resolver uno de los problemas más graves de la paternidad: saber que vacuna le toca a tu hijo/a en la próxima revisión.

## Calendario de vacunaciones. 

Por sí no lo sabéis, el calendario de vacunación infantil se basa en recomendaciones de la OMS que el Ministerio de Sanidad en colaboración con la Asociación Nacional de Pediatría estudia y presenta para que, posteriormente, las consejerías de sanidad de cada comunidad autónoma organicen como les de la gana. Esto hace que en España haya 19 calendarios diferentes que, además, suelen cambiar cada tres cuatro años. 

El objetivo de nuestra aplicación web será devolver un json con los 19 calendarios actualizados. Para ellos, nuestra aplicación necesitará de un panel de administración con el que actualizáremos las cinco tablas que forman el modelo de datos. 

![](file:///Users/javi/Developer/Proyectos/RoR/VacScheduler/diagram.png)

No voy a entrar en muchos detalles sobre el modelo. La primera tabla es la de países, inicialmente solo esta España pero creo que el modelo es extensible a cualquier país. Un país puede tener varios calendarios... como en España, que es una locura. Cada calendario tendrá una serie de eventos y cada evento tendrá, entre otros datos, una edad, una vacuna. Edades y Vacunas también son entidades del modelo de datos.

### Creación del proyecto

Siguiendo la estela de Rails, Padrino tiene generadores que nos vendrán muy bien en diferentes fases del desarrollo. El primero que utilizaremos es el que permite crear el proyecto. 

    $ padrino g project VacScheduler -t shoulda -e haml -c sass -s jquery -d activerecord -b
    
La mejor forma de saber que significan todos estos términos es mirar la [documentación de Padrino sobre los generadores](http://www.padrinorb.com/guides/generators). Yo he puesto todo esto, no porque sea un listillo, sino porque para hacer está aplicación me he fusilado el [tutorial sobre como hacer un blog](http://www.padrinorb.com/guides/blog-tutorial).    
Basicamente, hemos creado un proyecto llamado VacScheduler que usa shoulda para el testing, haml para el renderizado de las páginas, sass para los estilos, jquery para la parte de scripting y activerecord para el orm. Además, cuando termine la creación del proyecto, forzaremos una instalación de las gemas que nos faltan con Bundle.
    
### Creación del panel de administración (esto hará las delicias de más de uno)

Una gran diferencia con respecto a Rails es que, en Padrino han pensado que la existencia de un grupo de usuarios encargados de mantener las tablas que forman el modelo de la aplicación es un escenario lo suficientemente habitual como para crear una funcionalidad de Administración. A nosotros esto nos viene genial porque lo que queremos es tener una aplicación que devuelva una versión actualizada de los diferentes calendarios de vacunación y para actualizar esos datos tendremos a un usuario responsable de dicho mantenimiento. Las instrucciones para crear el panel de administración son las siguientes:

    $ padrino g admin --theme warehouse
    $ bundle install
    
    $ padrino rake ar:create
    $ padrino rake ar:migrate
    $ padrino rake seed
    
Este último paso nos pedirá un correo electrónico y una contraseña para poder acceder al panel de administración. Si después de hacer esto, arrancamos la aplicación podremos ver el bonito panel de administración.

    $ padrino start
    
### Creación de los modelos

Si estuviéramos en Rails, generaríamos un scaffold. Padrino no tiene scaffold... o si? igual nos llevamos una sorpresa más adelante.    
De momento vamos a crear los modelos de las cinco tablas que forman nuestro modelo de datos.

    $ padrino g model age short_name:string name:string months:integer -a app
    $ padrino g model calendar name:string country_id:integer -a app
    $ padrino g model country name:string -a app
    $ padrino g model event notes:text calendar_id:integer age_id:integer vaccine_id:integer -a app
    $ padrino g model vaccine short_name:string name:string description:text link_info:string -a app
    
y hacemos la migración correspondiente para crear las entidades en la base de datos:

    $ padrino rake ar:migrate
    
### Modificación de los modelos para incluir las relaciones y validaciones

Sobre los modelos que nos ha creado Padrino, hacemos las modificaciones oportunas para indicar las relaciones entre las entidades así como los campos que son obligatorios:

    # en age
    has_many :events
    validates_presence_of :short_name
    validates_presence_of :name
    validates_presence_of :months
    
    # en calendar
    has_many :events
    belongs_to :country
    validates_presence_of :name
    
    # en country
    has_many :calendars
    validates_presence_of :name
    
    # en event
    belongs_to :calendar
    belongs_to :age
    belongs_to :vaccine
    
    # en vaccine
    has_many :events
    validates_presence_of :short_name
    validates_presence_of :name
    
### Creación de los paneles de administración de cada uno de los modelos anteriores

Esto es lo que me ha ganado de Padrino. Las admin_page son unas pantallas de mantenimiento de datos semejantes a las creadas al hacer un scaffold de Rails pero vinculadas al panel de administración. Es decir, que solo serán visibles si estás autenticado en el sistema. Parece una chorrada, pero para hacer esto en Rails hay que picar un poquito.

    $ padrino g admin_page age
    $ padrino g admin_page calendar
    $ padrino g admin_page country
    $ padrino g admin_page event
    $ padrino g admin_page vaccine
    
Cuando refresquemos, veremos algo tan bonito como esto:

![](file:///Users/javi/Desktop/Captura%20de%20pantalla%202013-11-10%20a%20la(s)%2023.38.26.png)
    
![](file:///Users/javi/Desktop/Captura%20de%20pantalla%202013-11-10%20a%20la(s)%2023.39.09.png)

![](file:///Users/javi/Desktop/Captura%20de%20pantalla%202013-11-10%20a%20la(s)%2023.39.45.png)

### Un JSON con todos los calendarios.

El objetivo de la aplicación es enviar un JSON con la versión más actual de todos y cada uno de los calendarios para que una aplicación móvil refresque su base de datos y pueda informar a sus usuarios de cuales son las próximas vacunas que tienen que poner a sus criaturas.   
Ahora es cuando nos aprovechamos de que Padrino está montado sobre Sinatra y escribimos el siguiente trozo de código en app.rb:

    get "/" do
        Country.all.to_json(:include => { :calendars => {
                                :include => { :events => {
                                    :include => [
                                        { :vaccine => { :only => [:short_name, :name, :description, :link_info]}}, 
                                        { :age => { :only => [:months, :name, :short_name]}}],
                                    :only => :notes}},
                                :only => [:id, :name] }}, 
                            :only => [:id, :name])

    end

Y listo, con este *sencillo* fragmento de código toda la funcionalidad *publica* de nuestra aplicación web está construida. Ya podemos llamar desde la aplicación.

Si queréis echar un vistazo, en Heroku (como no) está instalada está misma aplicación: [VacScheduler](http://vacscheduler.herokuapp.com).

El código fuente de dicha aplicación lo podéis ver en 
    

    
