

defmodule MessageV1 do
  use Ecto.Schema

  embedded_schema do
    field :reply_to, :id
    embeds_many :message_parts, MessagePartV1
  end
end

defmodule MessagePartV1 do
  use Ecto.Schema

  embedded_schema do
    field :type_, :string
    field :data, :string
  end
end
