# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notificationモデルのテスト', type: :model do
  
  describe "モデルのテスト" do
    it "有効なNotificationの場合は保存されるか" do
      expect(build(:notification)).to be_valid
    end
  end
  
  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Notification.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Commentモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Notification.reflect_on_association(:comment).macro).to eq :belongs_to
      end
    end
    context 'Roomモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Notification.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
    context 'Messageモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Notification.reflect_on_association(:message).macro).to eq :belongs_to
      end
    end
    context 'Visitorモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Notification.reflect_on_association(:visitor).macro).to eq :belongs_to
      end
    end
    context 'Visitedモデルとの関係' do
      it '1対Nとなっているか' do
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
  end
end