require 'rails_helper'

RSpec.describe Permalink, type: :model do
    describe 'initializing a permalink' do
        it 'should succesfully build a permalink' do
            expect(build(:permalink)).to be_valid
            expect(create(:permalink).path).to_not eq nil
        end

        it 'should default to publicized:false, trashed:false' do
            expect(build(:permalink).publicized).to eq false
            expect(build(:permalink).trashed).to eq false
        end

        it 'should not let you define a custom path' do
            expect { create(:permalink, path: 'asdfasdfasdf') }.to raise_error(ArgumentError)
        end

        it 'creating a new record should increment Permalink count by 1' do
            expect { create(:permalink) }.to change { Permalink.count }.by 1
        end
    end
end
