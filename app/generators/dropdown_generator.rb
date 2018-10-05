# frozen_string_literal: true

class DropdownGenerator < QuestionTypeGenerator
  DROPDOWN_PLACEHOLDER = 'Selecteer uw antwoord...'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([
                content_tag(:p, title, class: 'flow-text'),
                answer_options(question)
              ])
  end

  private

  def answer_options(question)
    label = question[:label]
    elem_id = idify(question[:id])
    options = generate_dropdown(question, elem_id)
    options = safe_join([
                          content_tag(:label, label),
                          options
                        ])
    content_tag(:div, options, class: "col s12 m6 no-padding #{elem_id}")
  end

  def generate_dropdown(question, id)
    body = []
    placeholder = question[:placeholder] || DROPDOWN_PLACEHOLDER
    body << content_tag(:option, placeholder, disabled: true, selected: true, value: '')
    question[:options].each_with_index do |option, idx|
      body << content_tag(:option, option, value: question[:raw][:options][idx])
    end
    body = safe_join(body)
    content_tag(:select, body, name: answer_name(id), id: id, required: true, class: 'browser-default')
  end
end