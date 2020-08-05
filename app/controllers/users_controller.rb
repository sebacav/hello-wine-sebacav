class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # Esta accion, nos permite saltarnos el proceso de validacion de token,
  # para poder crear y loguear en la aplicacion
  skip_before_action :authorized, :only => [:create, :login]

  # Metodo que nos devuelve un arreglo con todas los usuarios ingresados
  def index
    @users = User.all
    render json: @users
  end

  # Metodo que nos permite obtener un usuario dado su identificador en formato json
  def show
    render json: @user
  end

  # Metodo que nos permite crear un usuario
  def create
    begin
      if request.content_type == "application/json" # Validamos el formato
        @user = User.new(user_params)
        if @user.email != nil # Validamos que exista un email y no sea nulo
          if @user.save
            token = encode_token({user_id: @user.id}) # Devolvemos un token en caso de que el usuario se haya creado
            render json: {token: token}, status: :created
          else
            render status: :bad_request
          end
        else
          render json: {problema: @user},status: :bad_request
        end
      else
        render status: :bad_request
      end
    rescue => exception
      # En caso de cualquier error que pueda ocurrir de formato u otro no capturado, devolveremos un status 400
      render json: {problema: exception}, status: :bad_request
    end
  end

  # Este meotodo es un extra y nos permite loguear, no es necesario para las pruebas,
  # debido a que las pruebas utilizan el mismo token de creacion
  def login
    @user = User.find_by(email: params[:email]) # Se busca un usuario basado en el email
    if @user && @user.authenticate(params[:password]) # Se valida usuario y se autentica con Bcrypt
      token = encode_token({user_id: @user.id}) # Si el usuario y password es correcto, entonces se crea token
      render json: {token: token}, status: :accepted
    else
      render status: :bad_request
    end
  end

  # Metodo que nos permite actualizar uno o mas campos dado el identificador de un usuario
  def update
    begin
      if request.content_type == "application/json" # Validamos el formato
        if @user.update(user_params)
          render json: @user
        else
          render status: :bad_request
        end
      else
        render status: :bad_request
      end
    rescue => exception
      # En caso de cualquier error que pueda ocurrir de formato u otro no capturado, devolveremos un status 400
      render status: :bad_request
    end
    
  end

  # Metodo que nos permite eliminar un usuario dado su identificador
  def destroy
    if @user.destroy
      render status: :ok
    else
      render status: :not_found
    end
  end

  private
    # Metodo privado que nos permite buscar un usuario dado el identificador
    # este metodo es convocado antes de ciertos metodos que estan descritos en
    # el before_action al principio del controlador
    def set_user
      begin
        @user = User.find(params[:id])
      rescue => exception
        # Si no se encuentra, entonces es necesario capturar la excepcion
        # devolviendo un status de no encontrado
        render status: :not_found
      end
    end

    # Metodo que nos permite formatear en un objeto, el json entrante en el body
    def user_params
      params.permit(:email, :nombre, :password)
    end
end
