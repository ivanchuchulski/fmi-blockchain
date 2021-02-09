import React, { Component } from "react";
import { Navbar, Nav, NavDropdown } from "react-bootstrap";
import "./AppNavbar.css";

class AppNavbar extends Component {
  render() {
    const { user } = this.props;
    return (
      <div className="appNavBar">
        <img className="navbar-logo-signme" src={""}></img>
        <Navbar bg="dark" expand="lg" variant="dark">
          <Navbar.Brand href="/view-causes">Home</Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse
            id="basic-navbar-nav"
            className="justify-content-between"
          >
            <Nav className="mr-auto">
              <Nav.Link href="/add-cause">Add cause</Nav.Link>
            </Nav>

            <NavDropdown title="Current user" id="basic-nav-dropdown">
              <NavDropdown.Item
                // TODO - obtain user
                href={"/my-causes/" + "currentUser"}
              >
                My causes
              </NavDropdown.Item>
              <NavDropdown.Divider />
            </NavDropdown>
          </Navbar.Collapse>
        </Navbar>
      </div>
    );
  }
}

export default AppNavbar;
