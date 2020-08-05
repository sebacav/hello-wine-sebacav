require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Se toma un objeto usuario ya fabricado por los fixtures
    @user = users(:one)
    # Se toma un usuario que no tiene referencias de ordenes, porque sino, no es posible
    # pasar la prueba de eliminacion, a menos que fuera un delet por cascada
    @user_no_reference = users(:three)
    # Se crea un usuario, para obtener el token
    post usuarios_url, params: { email: "auth@mail", nombre: @user.nombre, password: @user.password_digest }, as: :json
    # Se almacena el token de la respuesta
    @token = JSON.parse(response.body)["token"]
  end

  test "Al consultar GET /usuarios deberia obtener un status 200 " do
    get usuarios_url, headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "Al consultar GET /usuarios deberia obtener un Arreglo " do
    get usuarios_url, headers: { 'Authorization' => @token }, as: :json
    assert_kind_of Array, JSON.parse(response.body)
  end
  
  test "Al consultar GET /usuarios/:id deberia arrojar un status 200 si existe el usuario con la :id" do
    get usuarios_url(@user), headers: { 'Authorization' => @token }, as: :json
    assert_response :success
  end

  test "Al consultar GET /usuarios/:id deberia arrojar un status 404 si no existe el usuario con la :id" do
    get "/usuarios/500", headers: { 'Authorization' => @token }, as: :json
    assert_response :not_found
  end

  test "Al consultar POST /usuarios deberia crear una persona y arrojar status 201" do
    assert_difference('User.count') do
      post usuarios_url, params: { email: "test@mail.cc", nombre: @user.nombre, password: @user.password_digest }, as: :json
    end
    assert_response :created
  end

  test "Al consultar POST /usuarios deberia arrojar status 400, si no envio un email" do
    post usuarios_url, params: { nombre: @user.nombre, password: @user.password_digest }, as: :json
    assert_response :bad_request
  end

  test "Al consultar POST /usuarios deberia arrojar status 400 si el formato no es application/json" do
    post usuarios_url, headers: { 'Content-Type' => 'text/plain' }, params: { nombre: @user.nombre, password: @user.password_digest }, as: :json
    assert_response :bad_request
  end

  test "Al consultar PATCH /usuarios/:id deberia poder editar el EMAIL del usuario con la :id mencionada, y deberia devolver status 200" do
    patch "/usuarios/"+@user.id.to_s, headers: { 'Authorization' => @token }, params: { email: "updated@mail" }, as: :json
    assert_response 200
  end

  test "Al consultar PATCH /usuarios/:id deberia poder editar el NOMBRE del usuario con la :id mencionada, y deberia devolver status 200" do
    patch "/usuarios/"+@user.id.to_s, headers: { 'Authorization' => @token }, params: { nombre: "Juan" }, as: :json
    assert_response :success
  end

  test "Al consultar PATCH /usuarios/:id deberia arrojar status 404 si el :id de usuario, no existe" do
    patch "/usuarios/500", headers: { 'Authorization' => @token }, params: { email: "updated@mail" }, as: :json
    assert_response :not_found
  end

  test "Al consultar PATCH /usuarios/:id deberia arrojar status 400, si no se le envia un formato application/json" do
    patch "/usuarios/"+@user.id.to_s, headers: { 'Authorization' => @token, 'Content-Type' => 'text/plain' }, params: { email: "updated@mail" }, as: :json
    assert_response :bad_request
  end

  test "Al consultar DELETE /usuarios/:id deberia borrar el usuario y arrojar status 200" do
    assert_difference('User.count', -1) do
      delete "/usuarios/"+@user_no_reference.id.to_s, headers: { 'Authorization' => @token }, as: :json
    end
    assert_response :ok
  end

  test "Al consultar DELETE /usuarios/:id deberia arrojar status 404 si el usuario no existe" do
    delete "/usuarios/500", headers: { 'Authorization' => @token }, as: :json
    assert_response :not_found
  end

  # EXTRA  test de Autorizacion, se le remueve la autorizacion a cada metodo y no deberian poder ser accedidos

  test "Al consultar DELETE /usuarios/:id deberia arrojar status 401, si no hay token o el token no es valido" do
    delete "/usuarios/"+@user_no_reference.id.to_s, headers: { 'Authorization' => "secreto_invalido" }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar PATCH /usuarios/:id deberia arrojar status 401, si no hay token o el token no es valido" do
    patch "/usuarios/"+@user.id.to_s, headers: { 'Authorization' => "secreto_invalido" }, params: { nombre: "Juan" }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar GET /usuarios/:id deberia arrojar status 401, si no hay token o el token no es valido" do
    get usuarios_url(@user), headers: { 'Authorization' => "secreto_invalido" }, as: :json
    assert_response :unauthorized
  end

  test "Al consultar GET /usuarios deberia arrojar status 401, si no hay token o el token no es valido" do
    get usuarios_url, headers: { 'Authorization' => "secreto_invalido" }, as: :json
    assert_response :unauthorized
  end
end
