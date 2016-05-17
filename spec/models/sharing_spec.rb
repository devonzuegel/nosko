require 'rails_helper'

RSpec.describe Sharing, type: :model do
  let(:sharing) { create(:sharing) }

  it 'should make :share_by_default false by default' do
    expect(sharing.share_by_default).to eq false
  end
  it 'should make :reminders_frequency "Daily" by default' do
    expect(sharing.reminders_frequency).to eq Sharing::REMINDERS_FREQUENCY_OPTIONS.first
  end

  it 'should allow you to update :share_by_default' do
    expect { sharing.update_attributes(share_by_default: true) }
      .to change { sharing.share_by_default }
      .from(false).to(true)
  end

  it 'should allow you to update :reminders_frequency' do
    Sharing::REMINDERS_FREQUENCY_OPTIONS.reverse_each do |freq|
      expect { sharing.update_attributes(reminders_frequency: freq) }
        .to change { sharing.reminders_frequency }.to(freq)
    end
  end
end
