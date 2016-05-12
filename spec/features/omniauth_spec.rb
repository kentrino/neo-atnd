require "rails_helper"

RSpec.describe '/auth', type: :feature do
  subject { page }

  describe '/auth/twitter' do
    let(:user){ create :user }

    context 'success' do
      before do
        # モックのAuthオブジェクトを準備することで
        OmniAuth.config.mock_auth[:twitter] =
          OmniAuth::AuthHash.new({
                                   provider: 'twitter',
                                   uid: user.uid,
                                   info: {
                                     name: user.name,
                                     nickname: user.nickname,
                                     image: user.image,
                                     description: user.description
                                   },
                                   credentials: {
                                     token: user.token,
                                     secret: user.secret
                                   }
                                 })
        visit user_path id: user.id
        click_link 'log-in with Twitter'
      end

      # ログインしたらイベント一覧に移動する
      it { current_path.should eq events_path }

      # login as ユーザーネーム的な
      it { should have_content "login as #{user.name}" }

      # ログイン失敗がでていない
      it { should_not have_content 'login failure' }
    end

    context 'failure' do
      before do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
        visit user_path id: user.id
        click_link 'log-in with Twitter'
      end

      it { current_path.should eq events_path }

      # ログイン失敗のアラートがでている
      it { should have_content 'login failure' }
    end
  end

  # レイアウトってなんや
  describe 'layout' do
    context 'not logged-in' do
      let(:user){ create :user }

      before do
        # 他のユーザーパスに移動すると？
        visit user_path id: user.id
      end

      # そのユーザーのページに移動できて
      it { current_path.should eq user_path id: user.id }

      # ログインボタンがある
      it { should have_content 'log-in with Twitter' }
      it { should_not have_content 'log-out' }
    end

    # ログインした場合
    context 'logged-in' do
      let(:user){ create :user }

      before do
        login! user
        visit user_path id: user.id
      end

      # ユーザー用のパスにきちんと移動できて
      it { current_path.should eq user_path id: user.id }

      # ログアウトボタンがある
      it { should have_content 'log-out' }
      it { should_not have_content 'log-in with Twitter' }

      # ログアウトもちゃんとできる
      context 'exec log-out' do
        before do
          logout
          click_link 'log-out'
        end

        it { current_path.should eq events_path }
        it { should have_content 'log-in with Twitter' }
        it { should_not have_content 'log-out' }
      end
    end
  end
end
