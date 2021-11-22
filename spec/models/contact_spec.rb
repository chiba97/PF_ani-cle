# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contactモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { contact.valid? }

    let(:user) { create(:user) }
    let!(:contact) { build(:contact, user_id: user.id) }

    context 'titleカラム' do
      it '空欄ではないこと' do
        contact.title = ''
        is_expected.to eq false
      end
      it '３０文字以内であること：３０文字は○' do
        contact.title = Faker::Lorem.characters(number: 30)
        is_expected.to eq true
      end
      it '３０文字以内であること：３１文字は×' do
        contact.title = Faker::Lorem.characters(number: 31)
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄ではないこと' do
        contact.body = ''
        is_expected.to eq false
      end
      it '２００文字以内であること：２００文字は◯' do
        contact.body = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '２００文字以内であること：２０１文字は×' do
        contact.body = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1対Nであること' do
        expect(Contact.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
