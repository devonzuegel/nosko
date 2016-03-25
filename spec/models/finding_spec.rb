require 'rails_helper'

RSpec.describe Finding, type: :model do
  it 'should be an abstract class' do
    expect(Finding.abstract_class?).to be true
  end

  it 'should have the expected required fields' do
    expect(Finding::REQUIRED_FIELDS).to match_array %i(title source_url) # Ordering doesn't matter
  end

  it 'should have the expected optional fields' do
    expect(Finding::OPTIONAL_FIELDS).to match_array %i() # Ordering doesn't matter
  end
end
