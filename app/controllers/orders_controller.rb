class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # Metodo que nos devuelve un arreglo con todas las ordenes ingresadas
  def index
    @orders = Order.all
    render json: @orders
  end

  # Metodo que nos permite obtener una orden dado su identificador en formato json
  def show
    render json: @order
  end

  # Metodo que nos permite crear una orden
  def create
    begin

      if request.content_type == "application/json" # Validamos el formato
        @order = Order.new(order_params)
        if @order.user_id != nil # Validamos que exista un usuario valido antes de la query
          if @order.save
            render json: @order, status: :created
          else
            render status: :bad_request
          end
        end
      else
        render status: :bad_request
      end

    rescue => exception
      # En caso de cualquier error que pueda ocurrir de formato u otro no capturado, devolveremos un status 400
      render status: :bad_request
    end
  end

  # Metodo que nos permite actualizar uno o mas campos dado el identificador de una orden
  def update
    begin
      if request.content_type == "application/json" # Validamos el formato
        if @order.update(order_params)
          render json: @order
        else
          render status: :bad_request
        end
      end
    rescue => exception
      # En caso de cualquier error que pueda ocurrir de formato u otro no capturado, devolveremos un status 400
      render status: :bad_request
    end
    
  end

  # Metodo que nos permite eliminar una orden dado su identificador
  def destroy
    if @order.destroy
      render status: :ok
    else
      render status: :not_found
    end
    
  end

  private
    # Metodo privado que nos permite buscar una orden dado el identificador
    # este metodo es convocado antes de ciertos metodos que estan descritos en
    # el before_action al principio del controlador
    def set_order
      begin
        @order = Order.find(params[:id])
      rescue => exception
        # Si no se encuentra, entonces es necesario capturar la excepcion
        # devolviendo un status de no encontrado
        render status: :not_found
      end
    end

    # Metodo que nos permite formatear en un objeto, el json entrante en el body
    def order_params
      params.require(:order).permit(:monto, :estado_pago, :estado_orden, :fecha_pago, :fecha_entrega, :user_id)
    end
end
