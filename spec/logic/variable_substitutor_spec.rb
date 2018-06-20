# frozen_string_literal: true

require 'rails_helper'

describe VariableSubstitutor do
  describe 'substitute_variables' do
    let(:team) { FactoryBot.create(:team) }
    let(:student_role) { FactoryBot.create(:role, team: team, group: Person::STUDENT, title: Person::STUDENT) }
    let(:mentor_role) { FactoryBot.create(:role, team: team, group: Person::MENTOR, title: 'MentorTitle') }
    let(:student) { FactoryBot.create(:student, role: student_role, first_name: 'Emma', gender: Person::FEMALE) }
    let(:mentor) { FactoryBot.create(:mentor, role: mentor_role, first_name: 'Pieter', gender: Person::MALE) }

    describe 'substitute_variables' do
      let!(:prot_ment) { FactoryBot.create(:protocol_subscription, person: mentor, filling_out_for: student) }
      let!(:prot_stud) { FactoryBot.create(:protocol_subscription, person: student, filling_out_for: student) }

      describe 'with a student response' do
        let(:responseobj) { FactoryBot.create(:response, protocol_subscription: prot_stud) }

        it 'should return a hash' do
          result = described_class.substitute_variables(responseobj)
          expect(result).to be_a Hash
        end

        it 'should return the correct attributes' do
          result = described_class.substitute_variables(responseobj)

          expect(result[:mentor_title]).to eq mentor.role.title
          expect(result[:mentor_gender]).to eq mentor.gender
          expect(result[:mentor_name]).to eq mentor.first_name
          expect(result[:organization]).to eq student.role.team.organization.name
          expect(result[:student_name]).to eq student.first_name
          expect(result[:student_gender]).to eq student.gender
        end
      end

      describe 'with a mentor response' do
        let(:responseobj) { FactoryBot.create(:response, protocol_subscription: prot_ment) }
        it 'should return a hash' do
          result = described_class.substitute_variables(responseobj)
          expect(result).to be_a Hash
        end

        it 'should return the correct attributes' do
          result = described_class.substitute_variables(responseobj)

          expect(result[:mentor_title]).to eq mentor.role.title
          expect(result[:mentor_gender]).to eq mentor.gender
          expect(result[:mentor_name]).to eq mentor.first_name
          expect(result[:organization]).to eq student.role.team.organization.name
          expect(result[:student_name]).to eq student.first_name
          expect(result[:student_gender]).to eq student.gender
        end
      end
    end

    describe 'create_substitution_hash' do
      it 'should create the correct hash for a given student and mentor' do
        result = described_class.create_substitution_hash(mentor, student)
        expect(result[:mentor_title]).to eq mentor.role.title
        expect(result[:mentor_gender]).to eq mentor.gender
        expect(result[:mentor_name]).to eq mentor.first_name
        expect(result[:organization]).to eq student.role.team.organization.name
        expect(result[:student_name]).to eq student.first_name
        expect(result[:student_gender]).to eq student.gender
      end
    end
  end
end
