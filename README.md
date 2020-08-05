# Prueba para entrar a Hello Wine
En este documento, explicare los archivos que se han cambiado respecto a la estructura original de un proyecto en RoR.
El proyecto esta orientados a `API`, por lo cual no contiene Vistas. Al mismo tiempo fue iniciado, para usarse en `Postgres`, pero debido a pequeños percances con `Cloud SQL` y la versión en la que se creó Rails, no es posible generar las pruebas unitarias con modelos referenciales. Debido a esto es que el proyecto fue cambiado a `Mysql2`, pero de igual manera es posible levantarlo con Postgresql, cambiando los adaptadores y habilitando la `gem` que este en el archivo Gemfile.
Este proyecto fue creado, para ser desplegado en Cloud Run, mediante CI/CD desde GCP, por lo cual no es necesario ningún archivo .yml para este proyecto, debido a que se proporciona en el mismo Cloud Run, al momento de hacer el ambiente con integración a GitHub.


## Requisitos
Para instalar el proyecto localmente, se requiere tener instalado los siguientes componentes:
* Base de datos `Mysql 5.7 ` o superior 
* Debes tener instalado `Rails 5.2.4 ` (Solo necesarios para migración)
* Debes tener instalado `Ruby 2.6.6 `, en caso de tener otra versión puedes cambiarlo en el archivo Gemfile (Solo necesarios para migración)
* `Docker `, para poder correr el contendor.

## Instalacion

* Debemos correr los comandos para crear las base de datos de test y de producción con los siguientes comandos:

``` sh
rails db:create RAILS_ENV=test
rails db:migrate RAILS_ENV=test
rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production
```
Recuerda cambiar el archivo config/database.yml, tanto los default username y password, como los username y password de producción, que están escritos en forma de variables de entorno.

* Alternativamente, si no deseas instalar Rails y Ruby, puedes agregar las siguientes líneas en el Dockerfile, a continuación del `ENV PROD_PASSWORD=xxxxx`:

``` sh
# Iniciamos Rails para test
ENV RAILS_ENV=test
# Creamos y luego migramos el modelo de datos en test
RUN ["rails", "db:create"]
RUN ["rails", "db:migrate"]
```
Esto provocara que al hacer el build de docker, cree la primera vez la base de datos de prueba. También podemos agregar luego de `ENV RAILS_ENV=production` algo similar, para construir la base de datos de producción.

``` sh
# Iniciamos Rails para test
ENV RAILS_ENV=test
# Creamos y luego migramos el modelo de datos en test
RUN ["rails", "db:create"]
RUN ["rails", "db:migrate"]
```
posteriormente deberás comentar las líneas agregadas, debido a que este paso solo se hace una vez. Recuerda también cambiar los usuarios y contraseñas, tanto para la base de datos test, como la de producción.

## Archivos Importantes

``` sh
app/controller/application_controller.rb
app/controller/orders_controller.rb
app/controller/users_controller.rb
app/models/order.rb
app/models/user.rb
app/serializers/user.rb
test/controllers/orders_controller_test.rb
test/controllers/users_controller_test.rb
test/fixtures/users.yml
Dockerfile

```



