"use strict";

const ImageReducer = require("../libs/ImageReducer");
const ImageData    = require("../libs/ImageData");

const expect  = require("chai").expect;
const fs      = require("fs");
const path    = require("path");
const fixture = fs.readFileSync(path.join(__dirname, "/fixture/fixture.gif"), {encoding: "binary"});

describe("Reduce GIF Test", () => {
    let reducer;

    beforeEach(() => {
        reducer = new ImageReducer({quality: 90});
    });

    it("Reduce GIF", (done) => {
        const image = new ImageData("fixture/fixture.gif", "fixture", fixture);

        reducer.exec(image)
        .then((reduced) => {
            expect(reduced.data.length > 0).to.be.true;
            expect(reduced.data.length).to.be.below(fixture.length);
            done();
        })
        .catch((message) => {
            throw new Error(message);
            done();
        });
    });
});
