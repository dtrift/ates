# frozen_string_literal: true

module Web
  module Views
    module Tasks
      class New
        include Web::View

        def form
          form_for :task, routes.task_path, method: :post do
            div(class: 'form-group') do
              div(class: 'row') do
                div(class: 'col-8') do
                  text_field :title, placeholder: 'Task title', class: 'form-control'
                end
              end

              br

              div(class: 'row') do
                div(class: 'col-8') do
                  text_field :description, placeholder: 'Description', class: 'form-control'
                end
              end
            end

            div(class: 'row mt-4') do
              div(class: 'col') do
                submit 'Create', class: 'btn btn-success'
              end
            end
          end
        end
      end
    end
  end
end
