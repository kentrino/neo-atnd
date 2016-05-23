require "rails_helper"

RSpec.describe '/events', type: :feature do
  subject { page }
  # イベンツ
  describe '/events' do
    let!(:events) { create_list :event, 3 }
    before do
      visit events_path
    end

    # イベントタイトルがあって
    it { should have_content events.sample.title }

    # イベント詳細表示用のリンクが有る
    it { should have_link('Show', event_path(events.sample)) }


    # 詳細リンクをクリックすると
    context 'click show link' do
      before do
        find_link('Show', href: event_path(events.first)).click
      end

      # 詳細リンクがきちんと機能して、最初のサンプルイベントのページにとべる
      it 'should work show link' do
        current_path.should eq event_path(events.first)
      end
    end
  end

  # イベントページを叙述
  describe '/events/:id' do
    let(:event) { create :event }
    before do
      # イベントファクトリのイベントパスに移動
      visit event_path event
    end

    # イベントが満たすべきコンテンツ
    it { should have_content event.title }
    it { should have_content event.hold_at }
    it { should have_content event.capacity }
    it { should have_content event.location }
    it { should have_content event.owner }
    it { should have_content event.description }
    it { should have_css '#attendance' } #出席者リストのID
    it { should have_css '#absence' } #欠席者リストのID

    # ログインしていない状態では
    context 'not logged-in' do
      before do
        visit event_path event
      end

      # user-event にはatendフラグがいる
      # イベントのリンクがない
      it { should_not have_link('Edit', edit_event_path(event)) }
      it { should_not have_link('Destroy', event_path(event)) }
      it { should_not have_link('Absent', absent_event_path(event)) }
      it { should_not have_link('Attend', attend_event_path(event)) }

      # 参加者一覧
      # 参加者二名と不参加者に二名の十全なリストがある
      describe 'attendee' do
        let!(:attended) { create_list :attendee, 2, event: event }
        let!(:absent) { create_list :attendee, 2, event: event, absent: true } # status: 'absented'

        before do
          visit event_path event
        end
        it { should have_content attended.first.user.name }
        it { should have_content attended.last.user.name }
        it { should have_content absent.first.user.name }
        it { should have_content absent.last.user.name }
      end
    end
    # オーナーログイン状態
    context 'logged-in' do
      before do
        login!(event.user)
        visit event_path event
      end

      it { should have_link('Edit', edit_event_path(event)) }
      it { should have_link('Destroy', event_path(event)) }

      # 編集ボタンをおすと
      context 'click edit link' do
        before do
          find_link('Edit', href: edit_event_path(event)).click
        end

        # 編集用イベントパスに移動
        it { current_path.should eq edit_event_path(event) }
      end

      # 破棄
      context 'click destroy link' do
        before do
          find_link('Destroy', href: event_path(event)).click
        end

        # 破棄するとイベント一覧ページに移動する
        it 'should not have deleted event' do
          should_not have_content event.description
          expect(page).to have_current_path events_path
        end
      end

      # 参加者を叙述
      describe 'atendee' do

        # 不参加の場合
        context 'not attend' do
          it { should have_link('Attend', attend_event_path(event)) }

          context 'click Attend' do
            # 参加をおすと
            before do
              login!(event.user)
              click_link('Attend')
            end

            # イベントパスに移動し
            it { expect(page).to have_current_path event_path(event) }
            it { find('#attendance').should have_content event.user.name }
            it { find('#absence').should_not have_content event.user.name }

            # 欠席をおした時の動作を叙述する
            context 'click Absent' do
              before do
                click_link('Absent')
              end

              # 欠席したイベントのイベントパスを表示
              it { current_path.should eq event_path(event) }

              # 参加者から当該ユーザーがｔきちんと除外されている
              it { find('#attendance').should_not have_content event.user.name }
              it { find('#absence').should have_content event.user.name }

              context 'click Attend again' do
                before do
                  # 再び出席をおすと
                  click_link('Attend')
                end

                #
                it { current_path.should eq event_path(event) }
                it { find('#attendance').should have_content event.user.name }
                it { find('#absence').should_not have_content event.user.name }
              end
            end
          end
        end

        # すでに参加しているイベントは
        context 'already attended' do
          let!(:attended) { create :attendee, event: event, user: event.user }

          before do
            # イベントパスに移動し
            visit event_path event
          end

          # 欠席用リンクがある
          it { should have_link('Absent', absent_event_path(event)) }
        end
      end
    end
  end

  # イベント新規作成yay
  describe '/events/new' do

    # ログインしていないと新規作成できない
    context 'not logged-in' do
      before do
        #
        visit new_event_path
      end

      it 'should redirect events_path' do
        current_path.should eq events_path
      end
      it { should have_content 'Please login first.' }
    end

    # ログインしていると
    context 'logged-in' do
      let(:user) { create :user }
      let(:title) { 'test title' }
      before do
        # ヘルパー？
        login! user

        visit new_event_path
        fill_in 'event_title', with: title
        fill_in 'event_capacity', with: 10
        fill_in 'event_location', with: 'test location'
        fill_in 'event_owner', with: 'test owner'
        fill_in 'event_description', with: 'test description'
        find('#form > dd:nth-child(12) > button').click
        #click_button 'Create Event'
      end

      it { current_path.should eq event_path(Event.last) }
      it { should have_content title }
    end
  end

  # 編集機能
  describe '/events/edit' do
    let(:event) { create :event }

    context 'not logged-in' do
      # ログインしていない状態で編集リンクを押す
      before do
        visit edit_event_path event
      end

      # 認証されていないとイベント一覧へもどる
      it 'should redirect events_path' do
        current_path.should eq events_path
      end
      it { should have_content 'Please login first.' }
    end

    # ログインしている場合は
    context 'logged-in' do
      let(:title) { 'test title' }
      before do
        login! event.user
        visit edit_event_path event
        fill_in 'event_title', with: title
        click_button 'Update Event'
      end

      it { current_path.should eq event_path(event) }

      # きちんと編集できて、タイトルが変更されている
      it { should have_content title }
    end
  end
end
