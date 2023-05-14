defmodule VerdeWeb.BookLive.FormComponent do
  use VerdeWeb, :live_component

  alias Verde.Shelves

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage book records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="book-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:authors]}
          type="select"
          multiple
          label="Authors"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:content_type]} type="text" label="Content type" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:edition]} type="text" label="Edition" />
        <.input field={@form[:file_extension]} type="text" label="File extension" />
        <.input field={@form[:file_name]} type="text" label="File name" />
        <.input field={@form[:file_dir]} type="text" label="File dir" />
        <.input field={@form[:page_number]} type="number" label="Page number" />
        <.input field={@form[:published_in]} type="text" label="Published in" />
        <.input field={@form[:publisher]} type="text" label="Publisher" />
        <.input field={@form[:read_count]} type="number" label="Read count" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:volume]} type="text" label="Volume" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Book</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{book: book} = assigns, socket) do
    changeset = Shelves.change_book(book)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"book" => book_params}, socket) do
    changeset =
      socket.assigns.book
      |> Shelves.change_book(book_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"book" => book_params}, socket) do
    save_book(socket, socket.assigns.action, book_params)
  end

  defp save_book(socket, :edit, book_params) do
    case Shelves.update_book(socket.assigns.book, book_params) do
      {:ok, book} ->
        notify_parent({:saved, book})

        {:noreply,
         socket
         |> put_flash(:info, "Book updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_book(socket, :new, book_params) do
    case Shelves.create_book(book_params) do
      {:ok, book} ->
        notify_parent({:saved, book})

        {:noreply,
         socket
         |> put_flash(:info, "Book created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
