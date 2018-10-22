import React from 'react'
import {shallow} from 'enzyme'
import Login from 'components/admin_page_components/Login'

describe('Login', () => {
  let wrapper;
  let dummy_auth;

  beforeEach(() => {
    dummy_auth = jasmine.createSpyObj('auth', ['login', 'isAuthenticated', 'logout']);
    wrapper = shallow(<Login auth={dummy_auth}/>)
  });

  describe('login', () => {
    it("it should call the login function of the provided auth attribute", () => {
      expect(dummy_auth.login).not.toHaveBeenCalled()
      this.rendered.login();
      expect(dummy_auth.login).toHaveBeenCalled()
    });
  });

  describe('logout', () => {
    it("it should call the logout function of the provided auth attribute", () => {
      expect(this.dummy_auth.logout).not.toHaveBeenCalled()
      this.rendered.logout();
      expect(this.dummy_auth.logout).toHaveBeenCalled()
    });
  });

  describe('loginLogoutButton', () => {
    it("it should return a logout button of the person is currently logged in", () => {
      var logged_in = true;
      var result = this.rendered.loginLogoutButton(logged_in);
      expect(result.type).toEqual('a');
      expect(result.props.className).toEqual('waves-effect waves-light btn login-button');
      expect(result.props.children).toEqual('Log Out');
      expect(result.props.onClick.name.endsWith('logout')).toBeTruthy();
    });

    it("it should return a login button if the person is currently logged out", () => {
      var logged_in = false;
      var result = this.rendered.loginLogoutButton(logged_in);
      expect(result.type).toEqual('a');
      expect(result.props.className).toEqual('waves-effect waves-light btn login-button');
      expect(result.props.children).toEqual('Log In');
      expect(result.props.onClick.name.endsWith('login')).toBeTruthy();
    });
  });

  describe('render', () => {
    it("it should call the loginLogoutButton with true when the person is authenticated", () => {
      jest.spyOn(Login.prototype, 'loginLogoutButton').mockImplementation(() => {});

      component = React.createElement(Login, {
        auth: {
          isAuthenticated: () => {
            return true;
          }
        }
      });

      this.rendered = TestUtils.renderIntoDocument(component)
      expect(Login.prototype.loginLogoutButton).toHaveBeenCalledWith(true)
      expect(Login.prototype.loginLogoutButton.mock.calls.length).toEqual(1)

    });
    it("it should call the loginLogoutButton with false when the person is not authenticated", () => {
      jest.spyOn(Login.prototype, 'loginLogoutButton').mockImplementation(() => {});

      component = React.createElement(Login, {
        auth: {
          isAuthenticated: () => {
            return false;
          }
        }
      });

      this.rendered = TestUtils.renderIntoDocument(component)
      expect(Login.prototype.loginLogoutButton).toHaveBeenCalledWith(false)
      expect(Login.prototype.loginLogoutButton.mock.calls.length).toEqual(1)
    });
  });

});
