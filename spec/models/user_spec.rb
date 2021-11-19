# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  
  describe 'バリデーションのテスト' do
    subject { user.valid? }
    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄ではないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '２文字以上であること：１文字は×' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '２文字以上であること：２文字は○' do
        user.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '２０文字以下であること：２０文字は○' do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '２０文字以下であること：２１文字は×' do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一異性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end
    context 'petカラム' do
      it '２０文字以下であること：２０文字は○' do
        user.pet = Faker::Lorem.characters(number: 20) do
          is_expected.to eq true
        end
      end
      it '２０文字以下であること：２１文字は×' do
        user.pet = Faker::Lorem.characters(number: 21) do
          is_expected.to eq false
        end
      end
    end
    context 'introductionカラム' do
      it '５０文字以下であること：５０文字は○' do
        user.introduction = Faker::Lorem.characters(number: 50) do
        is_expected.to eq true
        end
      end
      it '５０文字以下であること：５１文字は×' do
        user.introduction = Faker::Lorem.characters(number: 51) do
          is_expected.to eq false
        end
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルのと関係' do
      it '１対Nとなっているか' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'Commentモデルのテスト' do
      it '1対Nとなっているか' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルのテスト' do
      it '1対Nとなっているか' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
      it '1対Nとなっているか' do
        expect(User.reflect_on_association(:favorited_posts).macro).to eq :has_many
      end
    end
    context 'Entryモデルのテスト' do
      it '1対Nとなっているか' do
        expect(User.reflect_on_association(:entries).macro).to eq :has_many
      end
    end
    context 'Messageモデルのテスト' do
      it '1対Nとなっているか' do
        expect(User.reflect_on_association(:messages).macro).to eq :has_many
      end
    end
    context 'Contactモデルのテスト' do
      it '1対Nとなっているか' do
        expect(User.reflect_on_association(:contacts).macro).to eq :has_many
      end
    end
    context 'Notificationモデルのテスト' do
      it '通知を送るユーザーと1対Nとなっているか' do
        expect(User.reflect_on_association(:active_notifications).macro).to eq :has_many
      end
      it '通知が送られるユーザーと1対Nなっているか' do
        expect(User.reflect_on_association(:passive_notifications).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルのテスト' do
      it 'フォローモデルと1対Nになっているか' do
        expect(User.reflect_on_association(:active_relationships).macro).to eq :has_many
      end
      it 'フォロワーモデルと1対Nになっているか' do
        expect(User.reflect_on_association(:passive_relationships).macro).to eq :has_many
      end
      it 'ユーザーモデル(フォローする側)と1対Nになっているか' do
        expect(User.reflect_on_association(:followings).macro).to eq :has_many
      end
      it 'ユーザーモデル（フォローされる側）と1対Nになっているか' do
        expect(User.reflect_on_association(:followers).macro).to eq :has_many
      end
    end
  end
end