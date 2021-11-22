# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entryモデルのテスト', type: :model do
  describe "モデルのテスト" do
    it "有効なEntryの場合は保存されるか" do
      expect(build(:entry)).to be_valid
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1+Nとなっているか' do
        expect(Entry.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Roomモデルとの関係' do
      it '1+Nとなっているか' do
        expect(Entry.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end
