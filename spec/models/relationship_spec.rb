# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationshipモデルのテスト', type: :model do
  
  describe 'アソシエーションのテスト' do
    context 'フォロー(フォローする人)モデルとの関係' do
      it '1+Nとなっているか' do
        expect(Relationship.reflect_on_association(:following).macro).to eq :belongs_to
      end
    end
    context 'フォロワー（フォローされる人）モデルとの関係' do
      it '1+Nとなっているか' do
        expect(Relationship.reflect_on_association(:follower).macro).to eq :belongs_to
      end
    end
  end
end