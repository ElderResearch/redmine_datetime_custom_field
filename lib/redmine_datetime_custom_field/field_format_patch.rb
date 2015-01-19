require 'redmine/field_format'

module Redmine
  module FieldFormat
    class DateFormat < Unbounded

      field_attributes :show_hours

      def cast_single_value(custom_field, value, customized=nil)
        (custom_field.show_hours=='1' ? value.to_time : value.to_date) rescue nil
      end

      def validate_single_value(custom_field, value, customized=nil)
        if ((value =~ /^\d{4}-\d{2}-\d{2}$/ && custom_field.show_hours!='1') || (value =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/ && custom_field.show_hours=='1')) && (value.to_date rescue false)
          []
        else
          [::I18n.t('activerecord.errors.messages.not_a_date')]
        end
      end

      def edit_tag(view, tag_id, tag_name, custom_value, options={})
        view.text_field_tag(tag_name, custom_value.value, options.merge(:id => tag_id, :size => 15)) +
          view.calendar_for(tag_id, custom_value.custom_field.show_hours=='1')
      end

      def bulk_edit_tag(view, tag_id, tag_name, custom_field, objects, value, options={})
        view.text_field_tag(tag_name, value, options.merge(:id => tag_id, :size => 15)) +
          view.calendar_for(tag_id, custom_field.show_hours=='1') +
            bulk_clear_tag(view, tag_id, tag_name, custom_field, value)
      end

    end
  end
end
