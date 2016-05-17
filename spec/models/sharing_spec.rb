require 'rails_helper'

RSpec.describe Sharing, type: :model do
  let(:sharing) { create(:sharing) }

  it 'should make :share_by_default false by default' do
    expect(sharing.share_by_default).to eq 'Only me'
  end
  it 'should make :reminders_frequency "Daily" by default' do
    expect(sharing.reminders_frequency).to eq 'Daily'
  end

  it 'should allow you to update :share_by_default' do
    Sharing.share_by_default_options.reverse_each do |opt|
      expect { sharing.update_attributes(share_by_default: opt) }.to change { sharing.share_by_default }.to(opt)
    end
  end

  it 'should allow you to update :reminders_frequency' do
    Sharing.reminders_frequency_options.reverse_each do |freq|
      expect { sharing.update_attributes(reminders_frequency: freq) }.to change { sharing.reminders_frequency }.to(freq)
    end
  end

  it 'should have the expected share_by_default_options' do
    expect(Sharing.share_by_defaults).to eq({ 'Only me' => 0, 'Friends' => 1, 'Public' => 2 })
    expect(Sharing.share_by_default_options).to eq ['Only me', 'Friends', 'Public']
  end

  it 'should have the expected reminders_frequency_options' do
    expect(Sharing.reminders_frequencies).to eq({ 'Daily' => 0, 'Every two days' => 1, 'Weekly' => 2 })
    expect(Sharing.reminders_frequency_options).to eq ['Daily', 'Every two days', 'Weekly']
  end
end
