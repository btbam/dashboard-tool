class ClaimsForAdjusterIdIndex < ActiveRecord::Migration
  def change
    add_index :features, :current_adjuster
    add_index :features, :claim_status
  end
end
