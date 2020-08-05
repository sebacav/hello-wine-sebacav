require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Se toma un objeto order ya fabricado por los fixtures
    @order = orders(:one)
    # Se toma un objeto usuario ya fabricado por los fixtures
    @user = users(:one)
    # se genera un nuevo usuario con un email diferente y se reutiliza el resto de la data del user one
    post usuarios_url, params: { email: "auth@mail", nombre: @user.nombre, password: @user.password_digest }, as: :json
    # se almacena el token que devuelve el metodo de creacion, para luego usarlo por los test
    @token = JSON.parse(response.body)["token"]
  end

  test "Al consultar GET /ordenes deberia obtener un status 200 " do
    get ordenes_url, headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "Al consultar GET /ordenes deberia obtener un Arreglo " do
    get ordenes_url, headers: { 'Authorization' => @token }, as: :json
    assert_kind_of Array, JSON.parse(response.body)
  end

  test "Al consultar GET /ordenes/:id deberia arrojar un status 200 si existe la orden con la :id" do
    get ordenes_url(@order), headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "Al consultar GET /ordenes/:id deberia arrojar un status 404 si no existe la orden con la :id" do
    get "/ordenes/500", headers: { 'Authorization' => @token }, as: :json
    assert_response :not_found
  end

  test "Al consultar POST /ordenes deberia crear una orden y arrojar status 201" do
    assert_difference('Order.count') do
      post ordenes_url, headers: { 'Authorization' => @token }, params: { estado_orden: @order.estado_orden, estado_pago: @order.estado_pago, fecha_entrega: @order.fecha_entrega, fecha_pago: @order.fecha_pago, user_id: @order.user_id }, as: :json
    end
    assert_response :created
  end

  test "Al consultar POST /ordenes deberia arrojar status 400, si no envio un user_id" do
    post usuarios_url, headers: { 'Authorization' => @token }, params: { estado_orden: @order.estado_orden, estado_pago: @order.estado_pago, fecha_entrega: @order.fecha_entrega, fecha_pago: @order.fecha_pago }, as: :json
    assert_response :bad_request
  end

  test "Al consultar POST /ordenes deberia arrojar status 400, si no envio un formato application/json" do
    post ordenes_url, headers: {'Authorization' => @token, 'Content-Type' => 'text/plain'}, params: { estado_orden: @order.estado_orden, estado_pago: @order.estado_pago, fecha_entrega: @order.fecha_entrega, fecha_pago: @order.fecha_pago, user_id: @order.user_id }, as: :json
    assert_response :bad_request
  end

  test "Al consultar PATCH /ordenes/:id deberia poder editar la ESTADO_PAGO de la orden con la :id mencionada, y deberia devolver status 200" do
    patch "/usuarios/"+@user.id.to_s, headers: {'Authorization' => @token }, params: { estado_pago: @order.estado_pago }, as: :json
    assert_response :ok
  end

  test "Al consultar PATCH /ordenes/:id deberia poder editar la ESTADO_ORDEN de la orden con la :id mencionada, y deberia devolver status 200" do
    patch "/usuarios/"+@user.id.to_s, headers: {'Authorization' => @token }, params: { estado_orden: @order.estado_orden }, as: :json
    assert_response :ok
  end

  test "Al consultar PATCH /ordenes/:id deberia arrojar status 404, al intentar editar ESTADO_PAGO, si es que el :id de la orden no existe" do
    patch "/usuarios/500", headers: {'Authorization' => @token }, params: { estado_pago: @order.estado_pago }, as: :json
    assert_response :not_found
  end

  test "Al consultar PATCH /ordenes/:id deberia arrojar status 400, al intentar editar ESTADO_PAGO, si no se le envia un formato application/json" do
    patch "/usuarios/"+@user.id.to_s, headers: {'Authorization' => @token, 'Content-Type' => 'text/plain' }, params: { estado_pago: @order.estado_pago }, as: :json
    assert_response :bad_request
  end

  test "Al consultar PATCH /ordenes/:id deberia arrojar status 404, al intentar editar ESTADO_ORDEN, si es que el :id de la orden no existe" do
    patch "/usuarios/500", headers: {'Authorization' => @token }, params: { estado_orden: @order.estado_orden }, as: :json
    assert_response :not_found
  end

  test "Al consultar PATCH /ordenes/:id deberia arrojar status 400, al intentar editar ESTADO_ORDEN, si no se le envia un formato application/json" do
    patch "/usuarios/"+@user.id.to_s, headers: {'Authorization' => @token, 'Content-Type' => 'text/plain' }, params: { estado_orden: @order.estado_orden }, as: :json
    assert_response :bad_request
  end

  test "Al consultar DELETE /ordenes/:id deberia borrar la orden y arrojar status 200" do
    assert_difference('Order.count', -1) do
      delete "/ordenes/"+@order.id.to_s, headers: { 'Authorization' => @token }, as: :json
    end
    assert_response :ok
  end

  test "Al consultar DELETE /ordenes/:id deberia arrojar status 404 si la orden no existe" do
    delete "/usuarios/500", headers: { 'Authorization' => @token }, as: :json
    assert_response :not_found
  end

  # EXTRA Autorizacion se le remueve la autorizacion a cada metodo y no deberian poder ser accedidos

  test "Al consultar DELETE /ordenes/:id deberia arrojar status 401, si no hay token o el token no es valido" do
    delete "/ordenes/"+@order.id.to_s, headers: {'Authorization' => "secreto_invalido" }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar PATCH /ordenes/:id deberia arrojar status 401, si no hay token o el token no es valido" do
    patch "/usuarios/"+@user.id.to_s, headers: {'Authorization' => "secreto_invalido" }, params: { estado_orden: @order.estado_orden }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar GET /ordenes/:id deberia arrojar status 401, si no hay token o el token no es valido" do
    get ordenes_url(@order), headers: { 'Authorization' => "secreto_invalido" }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar GET /ordenes deberia arrojar status 401, si no hay token o el token no es valido" do
    get ordenes_url, headers: { 'Authorization' => "secreto_invalido" }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar POST /ordenes deberia arrojar status 401, si no hay token o el token no es valido" do
    post ordenes_url, headers: { 'Authorization' => "secreto_invalido" }, params: { estado_orden: @order.estado_orden, estado_pago: @order.estado_pago, fecha_entrega: @order.fecha_entrega, fecha_pago: @order.fecha_pago, user_id: @order.user_id }, as: :json
    assert_response :unauthorized
  end


  
end
