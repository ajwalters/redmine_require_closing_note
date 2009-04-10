require_dependency 'issue'

module RequireClosingNotePatch
  
  def self.included(base)
    # base.extend RequireClosingNotePatchMethods
    base.send(:include, InstanceMethods)
    base.class_eval do
      # Make unloadable so this will work in development mode
      alias_method_chain :before_save, :note_required_on_close
    end
  end
  
  module InstanceMethods
    
    def before_save_with_note_required_on_close
      valid_save = before_save_without_note_required_on_close
      if require_note?
        # New records do _NOT_ have a notes field
        if journals.last.notes.blank?
          errors.add_to_base("A note is required when closing an issue")
          valid_save = false
        end
      end
      valid_save #= valid_save ? before_save_without_note_required_on_close : false
    end
    
    private
    
    # A note is not required for a new issue.  Notes are only required when the issues status is changed from an open status to a closed.
    def require_note?
      !new_record? && status_id_changed? && !IssueStatus.find(status_id_was).is_closed? && IssueStatus.find(status_id).is_closed?
    end
    
  end
    
end