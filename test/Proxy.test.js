const { expect } = require("chai");
const { BN, constants } = require("openzeppelin-test-helpers");
const { ZERO_ADDRESS } = constants;

const Proxy = artifacts.require("Proxy");
const ExampleIncrementer = artifacts.require("ExampleIncrementer");
const UpgradedExampleIncrementer = artifacts.require("UpgradedExampleIncrementer");

contract("Proxy", function ([root, other]) {
  it("should act like a proxy", async function() {
    // Deploy the template:
    this.template = await ExampleIncrementer.new();
    expect(await this.template.initialized()).to.be.false;
    expect(await this.template.count()).to.be.bignumber.eq(new BN(0));

    // Encode the setup data:
    const setupData = await this.template.encodeSetupData(1);
    
    // Deploy the Proxy:
    this.proxy = await Proxy.new(setupData, this.template.address);
    expect(this.proxy.address).to.not.be.eq(ZERO_ADDRESS);

    // Treat the proxy as ExampleIncrementer:
    this.proxy = await ExampleIncrementer.at(this.proxy.address);

    // Test if the setup has gone through OK:
    expect(await this.proxy.initialized()).to.be.true;
    expect(await this.proxy.count()).to.be.bignumber.eq(new BN(1));

    // Test increment:
    await this.proxy.increment({ from: other });
    expect(await this.proxy.count()).to.be.bignumber.eq(new BN(2));

    // Deploy the upgraded template:
    this.upgradedTemplate = await UpgradedExampleIncrementer.new();
    expect(await this.upgradedTemplate.initialized()).to.be.false;
    expect(await this.upgradedTemplate.count()).to.be.bignumber.eq(new BN(0));

    // Upgrade the contract code:
    await this.proxy.updateCode(this.upgradedTemplate.address, { from: root });
    
    // Code has been upgraded, check state:
    expect(await this.proxy.initialized()).to.be.true;
    expect(await this.proxy.count()).to.be.bignumber.eq(new BN(2));

    // Increment should change behavior:
    await this.proxy.increment({ from: root });
    expect(await this.proxy.count()).to.be.bignumber.eq(new BN(12));

  });
});
