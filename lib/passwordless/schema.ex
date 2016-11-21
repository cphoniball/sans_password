defmodule Passwordless.Schema do
  defmacro __using__(_) do
    quote do
      import Passwordless.Schema, only: :macros
      defdelegate passwordless_changeset(struct, params), to: Passwordless.Schema
    end
  end

  @login_fields ~w(login_token login_requested_at last_login_at)

  defmacro passwordless_schema() do
    quote do
      field :login_token, :string
      field :login_requested_at, Ecto.DateTime
      field :last_login_at, Ecto.DateTime
    end
  end

  def passwordless_changeset(struct, params \\ %{})
  def passwordless_changeset(struct, :invite) do
    passwordless_changeset(struct, %{
      login_token: Passwordless.Crypto.generate_token(),
      login_requested_at: Ecto.DateTime.utc
    })
  end
  def passwordless_changeset(struct, :callback) do
    passwordless_changeset(struct, %{
      login_token: nil,
      login_requested_at: nil,
      last_login_at: Ecto.DateTime.utc
    })
  end
  def passwordless_changeset(struct, params) do
    struct
    |> Ecto.Changeset.cast(params, @login_fields)
  end
end
