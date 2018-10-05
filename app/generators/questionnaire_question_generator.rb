# frozen_string_literal: true

class QuestionnaireQuestionGenerator < Generator
  # rubocop:disable Metrics/AbcSize
  def initialize
    @generators = {
      radio: RadioGenerator.new,
      time: TimeGenerator.new,
      checkbox: CheckboxGenerator.new,
      range: RangeGenerator.new,
      likert: LikertGenerator.new,
      textarea: TextareaGenerator.new,
      textfield: TextfieldGenerator.new,
      number: NumberGenerator.new,
      raw: RawGenerator.new,
      unsubscribe: UnsubscribeGenerator.new,
      date: DateGenerator.new,
      dropdown: DropdownGenerator.new,
      expandable: ExpandableGenerator.new,
      section_start: SectionStartGenerator.new,
      section_end: SectionEndGenerator.new,
      klasses: KlassesGenerator.new
    }
  end
  # rubocop:enable Metrics/AbcSize

  def generate(question)
    question_body = find_generator(question[:type]).generate(question)
    question_body = content_tag(:div, question_body, class: 'col s12')
    question_body = content_tag(:div, question_body,
                                class: find_generator(:klasses, only_questions: false).generate(question).to_s)
    wrap_question_in_sections(question_body, question)
  end

  private

  def find_generator(type, only_questions: true)
    generator = @generators[type]
    check_question_type_available(type, generator)
    check_question_type_allowed(type, generator, only_questions)
    generator
  end

  def wrap_question_in_sections(question_body, question)
    body = []
    body << find_generator(:section_start, only_questions: false).generate(question)
    body << question_body
    body << find_generator(:section_end, only_questions: false).generate(question)
    body.compact
  end

  def check_question_type_available(type, generator)
    raise "Unknown question type #{type}" unless generator.present?
  end

  def check_question_type_allowed(type, generator, only_questions)
    raise "Question type #{type} not allowed as question" if only_questions && !generator.is_a?(QuestionTypeGenerator)
  end
end