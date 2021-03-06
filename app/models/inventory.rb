## Inventory is a table that needs to have pestimistic locking.
#  This requires the SQL to be very fast in order to ensure the table is not locked.
#  Please keep the table free from extra data that might cause locking to become an issue.


# == Schema Information
#
# Table name: inventories
#
#  id                          :integer          not null, primary key
#  count_on_hand               :integer          default(0)
#  count_pending_to_customer   :integer          default(0)
#  count_pending_from_supplier :integer          default(0)
#

class Inventory < ActiveRecord::Base
  has_one :variant
  has_many :accounting_adjustments, :as => :adjustable

  validate :must_have_stock

  private

    def must_have_stock
      if (count_on_hand - count_pending_to_customer) < 0
        errors.add :count_on_hand, 'There is not enough stock to sell this item'
      end
    end
end
