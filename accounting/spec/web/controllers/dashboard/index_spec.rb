# frozen_string_literal: true

RSpec.describe Web::Controllers::Dashboard::Index, type: :action do
  subject { action.call(params) }

  let(:action) { described_class.new }

  let(:account) { Account.new(id: 1) }
  let(:params) { { 'rack.session' => session } }

  context 'when user authenticated' do
    let(:session) { { account: account } }

    it { expect(subject).to be_success }
  end

  context 'when user not authenticated' do
    let(:session) { {} }

    it { expect(subject).to redirect_to '/auth/login' }
  end
end
